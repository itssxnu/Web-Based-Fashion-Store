<div align="center">

# 🛒 Web-Based Fashion Store

**A full-featured e-commerce platform with live auctions, an AI shopping assistant, and role-based dashboards — all in one Spring Boot application.**

---

![Java](https://img.shields.io/badge/Java-17-orange?style=flat-square\&logo=openjdk)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-4.0.3-brightgreen?style=flat-square\&logo=springboot)
![Thymeleaf](https://img.shields.io/badge/Thymeleaf-Template_Engine-005F0F?style=flat-square\&logo=thymeleaf)
![MySQL](https://img.shields.io/badge/Database-MySQL-4479A1?style=flat-square\&logo=mysql)
![Maven](https://img.shields.io/badge/Build-Maven-C71A36?style=flat-square\&logo=apachemaven)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

<!-- ↓ Live GitHub stats — replace YOUR_USERNAME/YOUR_REPO once you push to GitHub ↓ -->
![Last Commit](https://img.shields.io/github/last-commit/itssxnu/Web-Based-Fashion-Store?style=flat-square\&label=Last%20Commit)
![Languages Count](https://img.shields.io/github/languages/count/itssxnu/Web-Based-Fashion-Store?style=flat-square\&label=Languages)
![Top Language](https://img.shields.io/github/languages/top/itssxnu/Web-Based-Fashion-Store?style=flat-square)

</div>

---

## Overview

**Web-Based Store** is a modular, production-ready e-commerce application built on Spring Boot. It goes beyond a simple product catalogue — combining a full buyer shopping experience, a seller self-service portal, and a powerful admin back-office into a single cohesive system.

### What makes it stand out

| ✨ Feature | Details |
|---|---|
| 🤖 AI Shopping Assistant | Integrated OpenRouter LLM chatbot for smart product discovery |
| 🔨 Live Auctions | Sellers can list items for bid; buyers can place and track bids in real time |
| 🔐 Google OAuth2 | One-click sign-in alongside traditional email/password |
| 📧 Rich Emails | Order confirmations, OTP codes, abandoned-cart reminders, and invoices |
| 📦 Smart Recommendations | Browsing-history-powered product recommendation engine |
| ⚖️ Product Comparison | Side-by-side spec comparison across multiple products |
| 💬 Seller Messaging | Buyer-to-seller direct messaging inbox |
| 📋 OTP Checkout | Extra verification step before payment to reduce fraud |

---

## Feature Matrix

<table>
<thead>
<tr><th>Role</th><th>Key Capabilities</th></tr>
</thead>
<tbody>

<tr>
<td><strong>Buyer / Customer</strong></td>
<td>Browse & search by category, manage cart & wishlist, compare products, place orders with OTP checkout, view invoices, write reviews, chat with AI assistant, message sellers, track order status.</td>
</tr>

<tr>
<td><strong>Seller</strong></td>
<td>CRUD product listings with variants, manage inventory, run live auctions, process & fulfil orders, respond to buyer messages and reviews, monitor dashboard analytics.</td>
</tr>

<tr>
<td><strong>Admin</strong></td>
<td>Manage all users, moderate products, configure categories and store policies, view platform-wide reports and analytics.</td>
</tr>

</tbody>
</table>

---

## Architecture

```
src/
├── main/
│   ├── java/com/app/store/
│   │   ├── config/              # SecurityConfig, DataSeeder
│   │   ├── controller/          # 26 HTTP controllers (buyer, seller, admin)
│   │   ├── dto/                 # Form-backing DTOs with validation
│   │   ├── entity/              # 21 JPA entities
│   │   ├── repository/          # Spring Data JPA repositories
│   │   ├── security/            # Custom UserDetails, OAuth2 handlers
│   │   ├── service/             # Business logic & impl layer
│   │   └── StoreApplication.java
│   └── resources/
│       ├── application.properties
│       ├── static/              # CSS, JS, images
│       └── templates/           # Thymeleaf views
│           ├── admin/           # Dashboard, users, products, reports, policies
│           ├── seller/          # Dashboard, products, orders, auctions, messages
│           ├── user/            # Orders, profile, invoice
│           └── *.html           # Storefront: index, shop, cart, checkout, wishlist…
└── test/
```

### Layer Breakdown

| Layer | Packages | Responsibility |
|---|---|---|
| **Security** | `security`, `config` | Spring Security, Google OAuth2, OTP flow |
| **Controller** | `controller` | HTTP routing, DTO binding, validation |
| **Service** | `service`, `service/impl` | Business rules, email, recommendations, AI chat |
| **Repository** | `repository` | Spring Data JPA — MySQL persistence |
| **Model** | `entity`, `dto` | JPA entities, form DTOs with Jakarta Bean Validation |
| **View** | `templates`, `static` | Thymeleaf + Thymeleaf Security Dialect, Layout Dialect |

---

## Domain Model (Key Entities)

```
User ──< Order ──< OrderItem >── Product ──< ProductVariant
 │                                  │
 ├──< Cart ──< CartItem              ├──< Review
 ├──< Wishlist ──< WishlistItem      ├──< Auction ──< Bid
 ├──< BrowsingHistory                └── Category
 ├──< Message
 ├──< Report
 └── Otp
```

---

## Technology Stack

| Concern | Technology |
|---|---|
| Language | Java 17 |
| Framework | Spring Boot 4.0.3 |
| Template Engine | Thymeleaf + Layout Dialect + Spring Security Extras |
| Persistence | Spring Data JPA / Hibernate (MySQL dialect) |
| Database | MySQL 8.x |
| Security | Spring Security · Google OAuth2 · OTP verification |
| Email | Spring Mail (SMTP / STARTTLS) |
| AI | OpenRouter API (configurable model) |
| Build | Maven Wrapper (`mvnw`) |
| Utilities | Lombok |

---

## Configuration

All secrets are supplied via **environment variables** — no credentials are committed to the repository.

| Variable | Purpose |
|---|---|
| `MYSQL_URL` | JDBC connection string, e.g. `jdbc:mysql://localhost:3306/store` |
| `MYSQL_USERNAME` | Database username |
| `MYSQL_PASSWORD` | Database password |
| `OAUTH2_CLIENT_ID` | Google OAuth2 client ID |
| `OAUTH2_CLIENT_SECRET` | Google OAuth2 client secret |
| `MAIL_HOST` | SMTP host (e.g. `smtp.gmail.com`) |
| `MAIL_PORT` | SMTP port (e.g. `587`) |
| `MAIL_USERNAME` | Sender email address |
| `MAIL_APP_PASSWORD` | SMTP app password |
| `OPENROUTER_API_KEY` | OpenRouter API key for the AI assistant |
| `OPENROUTER_MODEL` | Model identifier, e.g. `openai/gpt-4o-mini` |

Other notable defaults in `application.properties`:

```properties
server.port=8085
spring.jpa.hibernate.ddl-auto=update
spring.thymeleaf.cache=false
```

---

## Quick Start

### Prerequisites

- **Java 17** (JDK)
- **Maven** (or use the included wrapper)
- **MySQL 8.x** with a `store` schema created

### 1 — Clone

```powershell
git clone <your-repo-url>
```

### 2 — Set environment variables

```powershell
$env:MYSQL_URL       = "jdbc:mysql://localhost:3306/store"
$env:MYSQL_USERNAME  = "root"
$env:MYSQL_PASSWORD  = "your_password"
$env:OAUTH2_CLIENT_ID     = "..."
$env:OAUTH2_CLIENT_SECRET = "..."
$env:MAIL_HOST       = "smtp.gmail.com"
$env:MAIL_PORT       = "587"
$env:MAIL_USERNAME   = "you@gmail.com"
$env:MAIL_APP_PASSWORD    = "..."
$env:OPENROUTER_API_KEY   = "..."
$env:OPENROUTER_MODEL     = "openai/gpt-4o-mini"
```

### 3 — Run

```powershell
.\mvnw.cmd spring-boot:run
```

Visit: **http://localhost:8085**


---

<div align="center">
  <sub>Built with Spring Boot, Thymeleaf, and a passion for clean commerce.</sub>
</div>
