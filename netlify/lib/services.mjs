// Small helpers for Stripe and Supabase, written with plain fetch so the
// functions need no packages. Keys come from Netlify environment variables.
import crypto from "node:crypto";

const env = (k) => {
  const v = process.env[k];
  if (!v) throw new Error(`Missing environment variable ${k}`);
  return v;
};

// ─── Supabase (server key: bypasses row security, never sent to browsers) ───
export async function sb(path, { method = "GET", body, prefer } = {}) {
  const url = env("SUPABASE_URL").replace(/\/+$/, "") + "/rest/v1/" + path;
  const key = env("SUPABASE_SERVICE_ROLE_KEY");
  const res = await fetch(url, {
    method,
    headers: {
      apikey: key,
      Authorization: `Bearer ${key}`,
      "Content-Type": "application/json",
      ...(prefer ? { Prefer: prefer } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await res.text();
  if (!res.ok) throw new Error(`Supabase ${res.status}: ${text}`);
  return text ? JSON.parse(text) : null;
}

// ─── Stripe ─────────────────────────────────────────────────────────────────
function formEncode(obj, prefix, out = []) {
  for (const [k, v] of Object.entries(obj)) {
    if (v === undefined || v === null) continue;
    const key = prefix ? `${prefix}[${k}]` : k;
    if (typeof v === "object") formEncode(v, key, out);
    else out.push(`${encodeURIComponent(key)}=${encodeURIComponent(v)}`);
  }
  return out.join("&");
}

export async function stripe(path, params, method = "POST") {
  const res = await fetch("https://api.stripe.com/v1/" + path, {
    method,
    headers: {
      Authorization: `Bearer ${env("STRIPE_SECRET_KEY")}`,
      "Content-Type": "application/x-www-form-urlencoded",
    },
    body: params ? formEncode(params) : undefined,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(`Stripe ${res.status}: ${data?.error?.message}`);
  return data;
}

// Checks that a webhook really came from Stripe.
export function verifyStripeSignature(rawBody, header, toleranceSec = 300) {
  const secret = env("STRIPE_WEBHOOK_SECRET");
  const parts = Object.fromEntries(
    (header || "").split(",").map((p) => p.split("=").map((s) => s.trim()))
  );
  const sigs = (header || "")
    .split(",")
    .filter((p) => p.trim().startsWith("v1="))
    .map((p) => p.trim().slice(3));
  const t = Number(parts.t);
  if (!t || !sigs.length) return false;
  if (Math.abs(Date.now() / 1000 - t) > toleranceSec) return false;
  const expected = crypto
    .createHmac("sha256", secret)
    .update(`${t}.${rawBody}`)
    .digest("hex");
  return sigs.some(
    (s) =>
      s.length === expected.length &&
      crypto.timingSafeEqual(Buffer.from(s), Buffer.from(expected))
  );
}

export const json = (data, status = 200) =>
  new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json" },
  });
