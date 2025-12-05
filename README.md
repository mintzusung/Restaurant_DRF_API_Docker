# Django REST API – Food Ordering System

A backend API built with Django REST Framework (DRF) that provides a simple food-ordering workflow including menu management, cart, orders, and role-based access control. The project includes JWT authentication, custom permissions, and Docker + Nginx deployment.

---

## Features

### 1. Users & Authentication

* JWT authentication (`/api/token/`, `/api/token/refresh/`)
* Three roles:

  * **Admin**
  * **Manager**
  * **Delivery crew**
* Role assignment endpoints in `UserViewSet`

---

### 2. Menu Management

* Category CRUD
* Menu Item CRUD
* Optional query filters:

  * `?category=<id>`
  * `?sort=price`

---

### 3. Cart System

* Each authenticated user has their own cart
* Add, update, delete items
* Clear cart with:

```
DELETE /api/cart/clear/
```

---

### 4. Orders

* Create order from cart:

```
POST /api/orders/create_from_cart/
```

* Role-based visibility:

  * **User:** only own orders
  * **Manager/Admin:** all orders
  * **Delivery crew:** only assigned orders
* Manager actions:

  * Assign order to delivery crew
* Delivery crew actions:

  * Mark order as delivered

---

### 5. Deployment

* Docker + Gunicorn backend
* Nginx reverse proxy
* Static files served via Nginx (`STATIC_ROOT=/staticfiles`)

---

## Project Structure

```
APIsProject/
│
├── APIsapp/
│   ├── models.py         # Category, MenuItem, Cart, Order, OrderItem
│   ├── serializers.py    # DRF serializers including nested relations
│   ├── views.py          # ViewSets + custom actions
│   ├── permissions.py    # Custom role-based permissions
│   ├── urls.py           # Router endpoints
│
├── APIsProject/
│   ├── settings.py       # DRF, JWT, DB, static, installed apps
│   ├── urls.py           # JWT endpoints + app endpoints
│
├── docker-compose.yml    # Django + Nginx services
├── Dockerfile            # Backend container
├── Pipfile & Pipfile.lock
└── nginx/nginx.conf
```

---

## Tech Stack

* **Python 3.9**
* **Django 4.2**
* **Django REST Framework**
* **SimpleJWT**
* **SQLite (dev)**
* **Gunicorn**
* **Nginx**
* **Docker / Docker Compose**

---

## API Endpoints Overview

### Auth

| Method | Endpoint              | Description                 |
| ------ | --------------------- | --------------------------- |
| POST   | `/api/token/`         | Get access + refresh tokens |
| POST   | `/api/token/refresh/` | Refresh token               |

---

### Categories

| Endpoint           | Description     |
| ------------------ | --------------- |
| `/api/categories/` | CRUD categories |

---

### Menu

| Endpoint           | Description     |
| ------------------ | --------------- |
| `/api/menu-item/`  | CRUD menu items |
| `?category=<id>`   | Filter          |
| `?sort=price`      | Sort by price   |

---

### Cart

| Method | Endpoint           | Description |
| ------ | ------------------ | ----------- |
| GET    | `/api/cart/`       | List items  |
| POST   | `/api/cart/`       | Add item    |
         | DELETE | `/api/cart/{id}/`  | Remove item |
         | DELETE | `/api/cart/clear/` | Clear cart  |

---

### Orders

| Method | Endpoint                           | Description              |
| ------ | ---------------------------------- | ------------------------ |
| GET    | `/api/orders/`                     | CRUD orders              |
| POST   | `/api/orders/create_from_cart/`    | Create order             |
| DELETE | `/api/orders/{id}/`                | Delete order             |
| POST   | `/api/orders/{id}/assign_order/`   | Manager assigns          |
| PATCH  | `/api/orders/{id}/mark_delivered/` | Delivery marks delivered |

---

### Users

These actions require **Manager/Admin** permissions.

| Endpoint                        | Description            |
| ------------------------------- | ---------------------- |
| `/api/users/`                   | List all users         |
| `/api/users/{id}/set_manager/`  | Promote to Manager     |
| `/api/users/{id}/set_delivery/` | Add Delivery crew role |

---

## Permissions

Custom permissions are defined in `permissions.py`:

| Permission       | Who qualifies                 |
| ---------------- | ----------------------------- |
| `IsAdmin`        | User in "Admin" group         |
| `IsManager`      | User in "Manager" group       |
| `IsDeliveryCrew` | User in "Delivery crew" group |

DRF default permissions:

```python
'DEFAULT_PERMISSION_CLASSES': ['rest_framework.permissions.IsAuthenticated']
```

Some endpoints override with:

* `IsAuthenticatedOrReadOnly` (public menu access)
* Role permissions on specific actions

---

## Running the Project (Local)

### 1. Install dependencies

```
pipenv install
```

### 2. Apply migrations

```
python manage.py migrate
```

### 3. Run development server

```
python manage.py runserver
```

---

## Running with Docker

### 1. Build and start services

```
docker compose up -d --build
or
docker compose up -d --build --remove-orphans
```

### 2. Access URLs

`http://localhost`

---

## Environment Details

### Database

SQLite (default):

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}
```

### Static Files

```
STATIC_ROOT = /staticfiles
```

Served by Nginx via Docker volume.

