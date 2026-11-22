-- 003: data fasilitas disamakan dengan desain Figma (Hi Fi) + kolom detail.
-- Aman dijalankan ulang dan TIDAK menghapus baris: fasilitas lama di-UPDATE di tempat
-- (id sama, jadi pesanan yang sudah ada tetap valid), fasilitas baru di-INSERT.
alter table public.facilities
  add column if not exists address       text,
  add column if not exists size_text     text,
  add column if not exists capacity_text text,
  add column if not exists lighting_text text,
  add column if not exists review_count  integer not null default 0;

create temp table _nf as
select * from (values
  ('Lapangan Badminton GOR ITS','Lapangan Badminton','badminton','ITS Sports Center','Kampus ITS Sukolilo, Surabaya',
   'Lapangan badminton indoor dengan lantai karpet standar dan penerangan LED yang nyaman untuk latihan maupun pertandingan.',
   35000, 4.8, 96, true, true, 'assets/images/badminton.jpg', '13m x 6m','4 Pemain','Lampu LED 800 Lux',
   array['Toilet','Parkir','Mushola','Kantin'], array['Wajib sepatu olahraga non-marking','Dilarang membawa makanan ke area lapangan']),
  ('Lapangan Futsal ITS','Lapangan Futsal Outdoor','futsal','ITS Sports Center','Kampus ITS Sukolilo, Surabaya',
   'Lapangan futsal outdoor berlantai sintetis dengan pagar pengaman di sekeliling lapangan.',
   120000, 4.5, 64, false, true, 'assets/images/futsal_outdoor.jpg', '25m x 15m','12 Pemain','Lampu LED 1000 Lux',
   array['Toilet','Parkir','Ruang ganti'], array['Wajib sepatu futsal','Maksimal 12 pemain']),
  ('Lapangan Tenis ITS','GOR Pertamina','voli','ITS Sports Center','Kampus ITS Sukolilo, Surabaya',
   'Gedung olahraga serbaguna dengan tribun penonton, cocok untuk voli, futsal, dan event kampus.',
   500000, 4.9, 210, true, true, 'assets/images/gor_pertamina.jpg', '40m x 20m','800 Penonton','Lampu LED 1500 Lux',
   array['Toilet','Parkir','Tribun','Ruang ganti','Mushola'], array['Wajib sepatu olahraga non-marking','Dilarang merokok']),
  ('Lapangan Voli ITS','Lapangan Basket Indoor','basket','ITS Sports Center','Kampus ITS Sukolilo, Surabaya',
   'Lapangan basket indoor berlantai kayu dengan ring standar dan penerangan merata.',
   150000, 4.9, 118, true, true, 'assets/images/basket_indoor.jpg', '28m x 15m','200 Penonton','Lampu LED 1200 Lux',
   array['Toilet','Parkir','Tribun'], array['Wajib sepatu olahraga non-marking','Jaga kebersihan area']),
  ('Lapangan Basket ITS','Lapangan Basket Outdoor','basket','ITS Sports Center','Kampus ITS Sukolilo, Surabaya',
   'Lapangan basket outdoor dengan ring standar dan penerangan malam.',
   120000, 4.6, 72, false, false, 'assets/images/basket_outdoor.jpg', '28m x 15m','100 Penonton','Lampu LED 1000 Lux',
   array['Toilet','Parkir'], array['Dilarang merokok','Jaga kebersihan area']),
  (null,'Stadion Utama ITS','atletik','ITS Sports Center','Kampus ITS Sukolilo, Surabaya',
   'Stadion Utama ITS merupakan fasilitas olahraga bertaraf nasional yang terletak di jantung kampus ITS. Memiliki rumput alami berkualitas tinggi dengan sistem drainase modern, stadion ini cocok untuk pertandingan sepak bola formal maupun latihan rutin.',
   700000, 4.8, 120, false, true, 'assets/images/stadion_utama.jpg', '105m x 68m','1,000 Penonton','Lampu LED 1200 Lux',
   array['Toilet','Parkir','Tribun','Ruang ganti','Mushola'], array['Wajib sepatu bola/olahraga','Dilarang merokok di area lapangan'])
) as v(old_name, name, category, location, address, description, price_per_hour, rating, review_count,
       is_indoor, is_popular, image_url, size_text, capacity_text, lighting_text, amenities, rules);

update public.facilities f set
  name = n.name, category = n.category, location = n.location, address = n.address,
  description = n.description, price_per_hour = n.price_per_hour, rating = n.rating,
  review_count = n.review_count, is_indoor = n.is_indoor, is_popular = n.is_popular,
  image_url = n.image_url, size_text = n.size_text, capacity_text = n.capacity_text,
  lighting_text = n.lighting_text, amenities = n.amenities, rules = n.rules
from _nf n where f.name = n.old_name;

insert into public.facilities
  (name, category, location, address, description, price_per_hour, rating, review_count,
   is_indoor, is_popular, image_url, size_text, capacity_text, lighting_text, amenities, rules)
select n.name, n.category, n.location, n.address, n.description, n.price_per_hour, n.rating,
       n.review_count, n.is_indoor, n.is_popular, n.image_url, n.size_text, n.capacity_text,
       n.lighting_text, n.amenities, n.rules
from _nf n
where not exists (select 1 from public.facilities x where x.name = n.name);
