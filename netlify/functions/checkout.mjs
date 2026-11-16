// POST /api/checkout  { ids: ["item-id", ...] }
// Holds the items for 30 minutes, then sends the buyer to Stripe Checkout.
import crypto from "node:crypto";
import { sb, stripe, json } from "../lib/services.mjs";
import { quoteShipping } from "../../site/shop/shipping.js";

const HOLD_MINUTES = 35; // Stripe needs at least 30
const MAX_ITEMS = 20;

export default async (req) => {
  if (req.method !== "POST") return json({ error: "Use POST" }, 405);

  let ids;
  try {
    ({ ids } = await req.json());
  } catch {
    return json({ error: "Bad request" }, 400);
  }
  ids = [...new Set((ids || []).filter((x) => typeof x === "string"))];
  if (!ids.length || ids.length > MAX_ITEMS) {
    return json({ error: "Your bag is empty." }, 400);
  }

  const now = new Date();
  const holdUntil = new Date(now.getTime() + HOLD_MINUTES * 60 * 1000);
  const token = crypto.randomUUID();
  const idList = ids.map((i) => `"${i.replace(/"/g, "")}"`).join(",");

  // Claim every item that's free (available, or a hold that has run out).
  // Two buyers can never both claim the same item.
  const claimed = await sb(
    `products?id=in.(${idList})` +
      `&or=(status.eq.available,and(status.eq.reserved,reserved_until.lt.${now.toISOString()}))`,
    {
      method: "PATCH",
      prefer: "return=representation",
      body: { status: "reserved", hold_token: token, reserved_until: holdUntil.toISOString() },
    }
  );

  const release = () =>
    sb(`products?hold_token=eq.${token}&status=eq.reserved`, {
      method: "PATCH",
      body: { status: "available", hold_token: null, reserved_until: null },
    });

  if (claimed.length !== ids.length) {
    await release();
    const got = new Set(claimed.map((p) => p.id));
    return json(
      { error: "Someone got to it first.", unavailable: ids.filter((i) => !got.has(i)) },
      409
    );
  }

  try {
    const origin = process.env.URL_OVERRIDE || new URL(req.url).origin;
    const ship = quoteShipping(claimed);
    const abs = (src) => (/^https?:/.test(src) ? src : `${origin}/${src.replace(/^\/+/, "")}`);

    const params = {
      mode: "payment",
      success_url: `${origin}/shop/thanks/?session={CHECKOUT_SESSION_ID}`,
      cancel_url: `${origin}/shop/?canceled=1`,
      expires_at: Math.floor(holdUntil.getTime() / 1000),
      shipping_address_collection: { allowed_countries: { 0: "US" } },
      phone_number_collection: { enabled: "false" },
      metadata: { hold_token: token, product_ids: claimed.map((p) => p.id).join(",").slice(0, 500) },
      payment_intent_data: { metadata: { hold_token: token } },
      line_items: {},
      shipping_options: {
        0: {
          shipping_rate_data: {
            type: "fixed_amount",
            display_name: ship.label,
            fixed_amount: { amount: ship.cents, currency: "usd" },
            tax_behavior: "exclusive",
          },
        },
      },
    };

    claimed.forEach((p, i) => {
      params.line_items[i] = {
        quantity: 1,
        price_data: {
          currency: "usd",
          unit_amount: p.price_cents,
          tax_behavior: "exclusive",
          product_data: {
            name: p.title,
            description: [p.creator, p.year, p.condition].filter(Boolean).join(" · ") || undefined,
            images: p.images?.[0] ? { 0: abs(p.images[0]) } : undefined,
            metadata: { product_id: p.id },
          },
        },
      };
    });

    if (process.env.STRIPE_TAX === "on") params.automatic_tax = { enabled: "true" };

    const session = await stripe("checkout/sessions", params);
    return json({ url: session.url });
  } catch (err) {
    console.error(err);
    await release();
    return json({ error: "Checkout couldn't start. Please try again in a minute." }, 500);
  }
};

export const config = { path: "/api/checkout" };
