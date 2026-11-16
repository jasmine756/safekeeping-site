// Safekeeping shipping rules — used by the shop page (to show the price)
// and by checkout (to charge it). Change the numbers here and both update.

export const RATES = {
  mediaFirst: 499,      // USPS Media Mail, first book/CD
  mediaEach: 100,       // each extra book/CD
  groundDefault: {      // USPS Ground Advantage when an item has no custom price
    magazine: 799,
    decor: 1199,
    other: 999,
    book: 799,          // only used if a book is set to ground
    cd: 799,
  },
  groundEach: 200,      // each extra item in a ground box
  freeOverCents: null,  // e.g. 4000 = free shipping on orders $40+. null = off
};

export function groundPrice(item) {
  if (Number.isInteger(item.ship_price_cents)) return item.ship_price_cents;
  return RATES.groundDefault[item.category] ?? RATES.groundDefault.other;
}

// items: [{ category, ship_class, ship_price_cents, price_cents }]
export function quoteShipping(items) {
  if (!items.length) return { cents: 0, label: "", method: "none" };

  const subtotal = items.reduce((s, i) => s + i.price_cents, 0);
  if (RATES.freeOverCents && subtotal >= RATES.freeOverCents) {
    return { cents: 0, label: "Free shipping", method: "free" };
  }

  const allMedia = items.every((i) => i.ship_class === "media");
  if (allMedia) {
    return {
      cents: RATES.mediaFirst + RATES.mediaEach * (items.length - 1),
      label: "USPS Media Mail (2–8 business days)",
      method: "media",
    };
  }

  // Anything that can't go Media Mail moves the whole box to Ground Advantage:
  // the priciest item's rate, plus a small add-on for each other item.
  const top = Math.max(...items.map(groundPrice));
  return {
    cents: top + RATES.groundEach * (items.length - 1),
    label: "USPS Ground Advantage (2–5 business days)",
    method: "ground",
  };
}

export const money = (c) =>
  "$" + (c / 100).toFixed(c % 100 === 0 ? 0 : 2);
