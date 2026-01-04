# 💰 WealthWise — Investment Portfolio Tracker

WealthWise is a **FastAPI-based backend system** that allows users to manage their investment portfolios, record buy/sell transactions, and track holdings with **weighted average cost**, **profit/loss calculation**, and **JWT-based authentication**.

---

## 🚀 Features

- 🔐 **JWT Authentication** using OAuth2  
- 🧾 **CRUD operations** for users, instruments, and transactions  
- 📊 **Portfolio summary** with weighted average cost and real-time profit/loss  
- 💾 **Local JSON-based pricing system** (no external API required)  
- 🧠 **Error handling** for invalid trades (e.g., selling more than owned)  
- 🗃️ **PostgreSQL database** integration via SQLAlchemy ORM  
- 📦 Modular folder structure with Pydantic schemas and database models  

---

## 🧱 Tech Stack

| Layer | Technology |
|-------|-------------|
| Backend Framework | [FastAPI](https://fastapi.tiangolo.com/) |
| Database | [PostgreSQL](https://www.postgresql.org/) |
| ORM | [SQLAlchemy](https://www.sqlalchemy.org/) |
| Authentication | OAuth2 + JWT (`python-jose`) |
| Package Manager | [uv](https://github.com/astral-sh/uv) |
| Environment Variables | `python-dotenv` |
| Local Pricing | JSON data file |
| API Docs | Swagger UI (`/docs`) and ReDoc (`/redoc`) |

---

## ⚙️ Installation & Setup (using uv)

### 🧩 Clone the Repository
```bash
git clone https://github.com/salelkarayush/WealthNestAssignment.git
cd WealthNestAssignment
```

## ⚙️ Setting Up the Project (with `uv`)
- PostgreSQL installed and running
- `uv` package manager (see below)

### 📦 Install `uv`
If you don’t already have `uv`:

**macOS/Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```
**Windows(Powershell):**
```bash
iwr https://astral.sh/uv/install.ps1 -useb | iex
```
Create a new virtual environment managed by uv
```bash
uv venv
```
Activate It
**macOS/Linux:**
```bash
source .venv/bin/activate
```
**Windows(Powershell):**
```bash
.venv\Scripts\activate
```

### Install all project dependencies listed in pyproject.toml
```bash
uv sync
```

### Setup Virtual Environment
```bash
DATABASE_URL="postgresql+psycopg2://postgres:<your_password>@localhost:5432/wealthwise"

JWT_SECRET_KEY="your_jwt_secret_key"
```

### Create postgresql Database
```bash
CREATE DATABASE wealthwise;
```

### Run the setup script for database setup with sample data
```bash
psql -U postgres -d wealthwise -f setup.sql
```

## To run the Application
```bash
uv run main.py
```


### API will be live at
```bash
The API will be live at:
👉 http://127.0.0.1:8000

Interactive API Docs:
👉 http://127.0.0.1:8000/docs

Alternative Docs:
👉 http://127.0.0.1:8000/redoc
```
