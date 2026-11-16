// POST /api/stripe-webhook — Stripe calls this after a checkout finishes.
// Paid: items are marked sold and the order is saved.
// Expired or abandoned: items go back on the shelf.
import { sb, verifyStripeSignature, json } from "../lib/services.mjs";

export default async (req) => {
  const raw = await req.text();
  if (!verifyStripeSignature(raw, req.headers.get("stripe-signature"))) {
    return json({ error: "Bad signature" }, 400);
  }

  const event = JSON.parse(raw);
  const s = event.data?.object || {};
  const token = s.metadata?.hold_token;
  if (!token) return json({ ignored: true });

  if (event.type === "checkout.session.completed" && s.payment_status === "paid") {
    const sold = await sb(`products?hold_token=eq.${token}`, {
      method: "PATCH",
      prefer: "return=representation",
      body: { status: "sold", sold_at: new Date().toISOString(), reserved_until: null },
    });
    const details = s.customer_details || {};
    const shipping = s.collected_information?.shipping_details || s.shipping_details || null;
    await sb("orders?on_conflict=stripe_session_id", {
      method: "POST",
      prefer: "resolution=ignore-duplicates",
      body: {
        stripe_session_id: s.id,
        email: details.email || null,
        name: shipping?.name || details.name || null,
        shipping_address: shipping?.address || null,
        product_ids: sold.map((p) => p.id),
        subtotal_cents: s.amount_subtotal,
        shipping_cents: s.total_details?.amount_shipping ?? null,
        tax_cents: s.total_details?.amount_tax ?? null,
        total_cents: s.amount_total,
      },
    });
  }

  if (event.type === "checkout.session.expired") {
    await sb(`products?hold_token=eq.${token}&status=eq.reserved`, {
      method: "PATCH",
      body: { status: "available", hold_token: null, reserved_until: null },
    });
  }

  return json({ received: true });
};

export const config = { path: "/api/stripe-webhook" };
