-- Safekeeping Shop — first drop (12 books)
-- Run AFTER SHOP-SETUP.sql. Supabase: SQL Editor -> New query -> paste -> Run.
-- Safe to re-run: it updates the listing text/prices but never touches sold status.

insert into public.products (id, title, creator, year, category, ship_class, price_cents, condition, story, images, sort) values
('roots-boyce',
 'Roots: The Saga of an American Family — 30th Anniversary Edition, from the library of Jo Ann Allen Boyce',
 'Alex Haley · intro by Michael Eric Dyson', '2007', 'book', 'media', 10000,
 'Very good hardcover in dust jacket. Owner''s nameplate inside: "JoAnn C. Boyce, 2nd Edition, July 2007."',
 'This copy came from the Los Angeles estate sale of Jo Ann Allen Boyce. In 1956, at 14, she was one of the Clinton 12, the Black teenagers who walked into Clinton High School in Tennessee and became among the first to desegregate a public high school in the South. Her family moved to Los Angeles at the end of that year. Her handwriting is still on the nameplate. Some books you read. Some books were read by history.',
 array['assets/shop/roots-boyce-1.jpg','assets/shop/roots-boyce-2.jpg'], 1),

('self-seduction-signed',
 'Self-Seduction: Your Ultimate Path to Inner and Outer Beauty — signed and inscribed',
 'Mikki Taylor', '2003', 'book', 'media', 6500,
 'Hardcover in dust jacket, light jacket wear. Inscribed "To Hope, Many blessings and love!" and signed, dated 6/7/03.',
 'Before every beauty influencer, there was Mikki Taylor at Essence. This copy was signed on her book tour, and whoever stood in line that day kept everything: the original June 7, 2003 tour bookmark with its butterfly charm and the "Please Personalize / Sign Book For:" slip are still tucked inside. A whole Saturday afternoon, preserved.',
 array['assets/shop/self-seduction-signed-1.jpg','assets/shop/self-seduction-signed-2.jpg','assets/shop/self-seduction-signed-3.jpg'], 2),

('we-are-all-the-black-boy-signed',
 'We Are All the Black Boy — signed first edition',
 'Michael Warr', '1991', 'book', 'media', 4000,
 'Paperback, bright clean cover. Inscribed and signed by the author on the title page.',
 'Chicago poetry from Tia Chucha Press, the small press that put out some of the most vital voices of the early ''90s. A slim first edition with a full-color cover that looks like a gallery wall, and a warm inscription from the poet himself. Small-press poetry rarely survives. Signed small-press poetry, even less.',
 array['assets/shop/we-are-all-the-black-boy-signed-1.jpg','assets/shop/we-are-all-the-black-boy-signed-2.jpg'], 3),

('if-they-come-in-the-morning',
 'If They Come in the Morning: Voices of Resistance — first Signet printing',
 'Angela Y. Davis · foreword by Julian Bond', '1971', 'book', 'media', 4500,
 'Mass-market paperback, First Printing, December 1971. Cover creases and edge chips, tanned pages, text complete.',
 'Published while she was still in jail awaiting trial, with writing from Angela Davis, George Jackson, Huey P. Newton and James Baldwin''s "An Open Letter to Angela Y. Davis." This is the first Signet printing, $1.25 on the cover, the copy people passed hand to hand. It looks like it was read with purpose.',
 array['assets/shop/if-they-come-in-the-morning-1.jpg','assets/shop/if-they-come-in-the-morning-2.jpg'], 4),

('malcolm-x-grove-1966',
 'The Autobiography of Malcolm X — Grove Press paperback',
 'Malcolm X with Alex Haley', '1966', 'book', 'media', 3000,
 'Mass-market paperback, first paperback edition (25th printing), $1.50 cover price. Spine wear, tanned pages, red page edges.',
 'The Grove Press black-and-red paperback. If you grew up in a house with books, there is a good chance this exact cover was on the shelf. Red-edged pages, the $1.50 price still on the front.',
 array['assets/shop/malcolm-x-grove-1966-1.jpg','assets/shop/malcolm-x-grove-1966-2.jpg'], 5),

('destruction-black-civilization',
 'The Destruction of Black Civilization: Great Issues of a Race from 4500 B.C. to 2000 A.D.',
 'Chancellor Williams', '1987', 'book', 'media', 2500,
 'Third World Press paperback, third edition. Clean, near new.',
 'Howard historian Chancellor Williams'' landmark, in the Third World Press edition out of Chicago. The book that lived on every serious bookshelf, usually next to the encyclopedias. This one is clean enough to start the tradition over.',
 array['assets/shop/destruction-black-civilization-1.jpg'], 6),

('roll-jordan-roll',
 'Roll, Jordan, Roll: The World the Slaves Made',
 'Eugene D. Genovese', '1976', 'book', 'media', 2500,
 'Paperback, First Vintage Books Edition, February 1976. Edge wear, tanned pages.',
 'The thick red-and-gold Vintage paperback from 1976, with a cover designed like a vintage label. A doorstop of a history book that every grad student carried around in the ''70s and ''80s.',
 array['assets/shop/roll-jordan-roll-1.jpg'], 7),

('negro-making-america-early',
 'The Negro in the Making of America — early Collier paperback',
 'Benjamin Quarles', 'c. 1969', 'book', 'media', 2200,
 'Paperback, $1.25 cover price. Well loved: cover creases, chips at spine and corners.',
 'The blue textured-cover edition, "updated through the rise of Black Power, the years of Watts and Chicago, Malcolm X and Martin Luther King." It shows its miles, but this is the edition your teacher had.',
 array['assets/shop/negro-making-america-early-1.jpg'], 8),

('roots-dell-1977',
 'Roots: The Saga of an American Family — 1977 Dell paperback',
 'Alex Haley', '1977', 'book', 'media', 2000,
 'Mass-market paperback, third Dell printing (December 1977), $2.75 cover price. Spine creasing, edge wear, tanned pages.',
 'The brick-thick Dell paperback everybody bought the winter after the miniseries. Third printing, December 1977, which means somebody went out and got it the minute it hit the racks.',
 array['assets/shop/roots-dell-1977-1.jpg','assets/shop/roots-dell-1977-2.jpg'], 9),

('race-matters-1994',
 'Race Matters',
 'Cornel West', '1994', 'book', 'media', 2000,
 'Paperback, First Vintage Books Edition, April 1994. Good, clean.',
 'Cornel West in the three-piece suit, arms folded. The 1994 first Vintage paperback, back when this was the book everyone was arguing about at the cookout.',
 array['assets/shop/race-matters-1994-1.jpg'], 10),

('negro-making-america-3rd',
 'The Negro in the Making of America — third edition, revised and expanded',
 'Benjamin Quarles', '', 'book', 'media', 2000,
 'Collier paperback. Clean.',
 'Benjamin Quarles'' classic survey in the later revised and expanded Collier edition. Pair it with the early blue copy if you like your history in stereo.',
 array['assets/shop/negro-making-america-3rd-1.jpg'], 11),

('between-the-world-and-me',
 'Between the World and Me',
 'Ta-Nehisi Coates', '2015', 'book', 'media', 1800,
 'Hardcover in dust jacket, later printing. A few light spots on the jacket.',
 'The National Book Award winner, written as a letter from a father to his son. The textured white jacket in hardcover, the version that sat on every coffee table in 2015.',
 array['assets/shop/between-the-world-and-me-1.jpg'], 12)

on conflict (id) do update set
  title = excluded.title, creator = excluded.creator, year = excluded.year,
  category = excluded.category, ship_class = excluded.ship_class,
  price_cents = excluded.price_cents, condition = excluded.condition,
  story = excluded.story, images = excluded.images, sort = excluded.sort;
