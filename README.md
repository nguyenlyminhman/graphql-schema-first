# graphql-schema-first

A NestJS GraphQL API built using the **schema-first** approach, integrated with Prisma ORM and PostgreSQL. The API covers four feature domains — **User**, **Auth**, **Post**, and **Category** — with JWT-based authentication and role-based access control.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | [NestJS](https://nestjs.com/) v9 |
| API | GraphQL (Schema-First) via `@nestjs/graphql` + Apollo Server v4 |
| Database | PostgreSQL |
| ORM | [Prisma](https://www.prisma.io/) v5 |
| Auth | JWT (`@nestjs/jwt`) + bcrypt |
| Real-time | GraphQL Subscriptions (`graphql-subscriptions`) |
| Validation | `class-validator` + `class-transformer` |
| Language | TypeScript |

---

## Project Structure

```
graphql-schema-first/
├── prisma/
│   ├── schema.prisma                   # Prisma data model
│   └── migrations/                     # Migration history
│       ├── 20240210160915_my_graphql/
│       └── 20240215063153_mygraphql/
│
├── src/
│   ├── app.module.ts                   # Root NestJS module
│   ├── main.ts                         # Application entry point
│   ├── generate-typings.ts             # Script: generate TS types from .graphql SDL
│   ├── error.ts                        # Global error handling
│   │
│   ├── common/
│   │   ├── date-scalar.ts              # Custom GraphQL Date scalar
│   │   └── utils.ts                    # Shared utility functions
│   │
│   ├── database/
│   │   ├── database.module.ts          # Prisma module registration
│   │   └── prisma.service.ts           # PrismaClient service wrapper
│   │
│   ├── graphql/
│   │   └── graphql.schema.ts           # Auto-generated GraphQL schema types
│   │
│   ├── object/
│   │   ├── constant/index.ts           # App-wide constants
│   │   ├── decorators/user.decorator.ts # @CurrentUser param decorator
│   │   ├── enums/
│   │   │   ├── log.enum.ts             # Log level enum
│   │   │   └── user.permissions.enum.ts # User permission enum
│   │   └── roles.decorator.ts          # @Roles metadata decorator
│   │
│   └── modules/
│       ├── auth/                       # Authentication module
│       │   ├── auth.graphql            # Auth SDL (login mutation, token type)
│       │   ├── auth.guard.ts           # JWT AuthGuard
│       │   ├── auth.module.ts
│       │   ├── auth.resolver.ts
│       │   ├── auth.service.ts
│       │   └── dtos/auth-user.dto.ts
│       │
│       ├── user/                       # User CRUD module
│       │   ├── user.graphql            # User SDL (queries, mutations, types)
│       │   ├── user.module.ts
│       │   ├── user.resolver.ts
│       │   ├── user.service.ts
│       │   └── dto/create-user.dto.ts
│       │
│       ├── post/                       # Post module
│       │   ├── post.graphql
│       │   ├── post.module.ts
│       │   ├── post.resolver.ts
│       │   ├── post.service.ts
│       │   └── dto/create-post.dto.ts
│       │
│       └── category/                   # Category module
│           ├── category.graphql
│           ├── category.module.ts
│           ├── category.resolver.ts
│           ├── category.service.ts
│           └── dto/create-category.dto.ts
│
├── test/
│   ├── app.e2e-spec.ts
│   └── jest-e2e.json
│
├── query.script.txt                    # Sample GraphQL queries & mutations
├── .env.example
└── package.json
```

---

## Prerequisites

- Node.js >= 16
- PostgreSQL running locally (or a remote connection string)
- npm

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/nguyenlyminhman/graphql-schema-first.git
cd graphql-schema-first
```

### 2. Install dependencies

```bash
npm install
```

### 3. Configure environment variables

```bash
cp .env.example .env
```

Edit `.env` and set your PostgreSQL connection string:

```env
DATABASE_URL="postgresql://<user>:<password>@localhost:5432/<dbname>?schema=public"
```

### 4. Run database migrations

```bash
npm run db:migrate
```

Applies all pending Prisma migrations defined in `prisma/migrations/`.

### 5. Generate GraphQL TypeScript typings

```bash
npm run generate:typing
```

Uses `ts-morph` to generate TypeScript types from the `.graphql` SDL files into `src/graphql/graphql.schema.ts`. Re-run this whenever you modify a `.graphql` file.

---

## Running the Application

```bash
# Development mode
npm run start

# Watch mode (auto-reload on file changes)
npm run start:dev

# Debug mode
npm run start:debug

# Production mode
npm run start:prod
```

The GraphQL Playground / Apollo Sandbox is available at:

```
http://localhost:3000/graphql
```

---

## Modules

### Auth
Handles login and JWT token issuance. Protected resolvers use `AuthGuard` which validates the Bearer token from the request header.

### User
CRUD operations for user accounts. Passwords are hashed with bcrypt before storage.

### Post
Create and query posts. Posts are associated with a user and a category.

### Category
Create and query categories used to organize posts.

---

## Example Queries & Mutations

See the full list in [`query.script.txt`](./query.script.txt). Quick samples:

**Create a user:**
```graphql
mutation createUser {
  createUser(createUserInput: {
    fullname: "John Doe"
    email: "john@example.com"
    password: "secret123"
  }) {
    id
    fullname
    email
  }
}
```

**Get a user by ID:**
```graphql
query user {
  user(id: 1) {
    id
    email
    fullname
  }
}
```

**Get all users:**
```graphql
query users {
  users {
    id
    email
    fullname
  }
}
```

---

## Key Scripts

| Script | Description |
|---|---|
| `npm run start:dev` | Start in watch/dev mode |
| `npm run build` | Compile TypeScript to `dist/` |
| `npm run generate:typing` | Regenerate TS types from `.graphql` SDL files |
| `npm run db:migrate` | Apply Prisma migrations |
| `npm run lint` | Run ESLint with auto-fix |
| `npm run format` | Run Prettier formatter |

---

## Testing

```bash
# Unit tests
npm run test

# Watch mode
npm run test:watch

# Coverage report
npm run test:cov

# End-to-end tests
npm run test:e2e
```

---

## Schema-First Approach

This project uses the **schema-first** method:

1. The GraphQL schema is defined in `.graphql` SDL files inside each feature module (e.g. `user.graphql`, `post.graphql`).
2. NestJS reads these files at runtime via the `typePaths` option in `GraphQLModule.forRoot()`.
3. TypeScript types matching the schema are generated via `npm run generate:typing` and written to `src/graphql/graphql.schema.ts`.

This keeps the GraphQL contract explicit and decoupled from the TypeScript implementation, unlike the code-first approach where decorators drive schema generation.

---

## License

This project is UNLICENSED (private use).
