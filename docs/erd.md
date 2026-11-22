# ERD FasorITS

Diagram Mermaid di bawah dirender otomatis oleh GitHub.

```mermaid
erDiagram
    AUTH_USERS ||--|| PROFILES : "1 akun = 1 profil"
    PROFILES   ||--o{ BOOKINGS : "membuat"
    FACILITIES ||--o{ BOOKINGS : "dipesan"
    FACILITIES ||--o{ BOOKED_SLOTS : "memiliki"
    BOOKINGS   ||--|{ BOOKED_SLOTS : "mengunci"
    BOOKINGS   ||--|| PAYMENTS : "ditagih"

    AUTH_USERS {
        uuid id PK
        text email
        jsonb raw_user_meta_data
    }
    PROFILES {
        uuid id PK, FK
        text full_name
        text nrp UK
        text email
        text user_type "mahasiswa | umum"
        timestamptz created_at
    }
    FACILITIES {
        uuid id PK
        text name
        text category "badminton | futsal | basket | tenis | voli | atletik"
        text location
        text description
        int price_per_hour
        numeric rating
        bool is_indoor
        bool is_popular
        text image_url
        int open_hour
        int close_hour
        text_array amenities
        text_array rules
    }
    BOOKINGS {
        uuid id PK
        text booking_code UK
        uuid user_id FK
        uuid facility_id FK
        date booking_date
        int start_hour
        int end_hour
        int rental_fee
        int service_fee
        int total
        text status "pending | paid | completed | expired | cancelled"
        timestamptz created_at
    }
    BOOKED_SLOTS {
        bigint id PK
        uuid facility_id FK
        date slot_date
        int start_hour
        uuid booking_id FK
    }
    PAYMENTS {
        uuid id PK
        uuid booking_id FK, UK
        text method "QRIS"
        int amount
        text status "pending | paid | failed | expired"
        text transaction_id
        timestamptz expires_at
        timestamptz paid_at
    }
```

Aturan integritas penting:

- `booked_slots`: `UNIQUE (facility_id, slot_date, start_hour)` mencegah double booking.
- `bookings`: `EXCLUDE` pada (`facility_id`, `booking_date`, rentang `start_hour`..`end_hour`) untuk pesanan aktif.
- Semua foreign key ke `bookings`/`profiles` memakai `ON DELETE CASCADE` (dasar fitur hapus akun dan batal pesanan).
