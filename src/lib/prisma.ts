import { PrismaMssql } from "@prisma/adapter-mssql";
import { PrismaClient } from "../generated/prisma/client";
// @ts-expect-error this file is bundled as a binary.
import pemFile from "./eu-west-1-bundle.pem";

console.log("Before creating SQL config");

const sqlConfig = {
  user: process.env.DB_USER!,
  password: process.env.DB_PASSWORD!,
  database: process.env.DB_NAME!,
  server: process.env.DB_HOST!,
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
  options: {
    encrypt: true,
    trustServerCertificate: process.env.ENVIRONMENT === "local",
    cryptoCredentialsDetails: {
      ca: Buffer.from(pemFile),
    },
  },
};

console.log("SQL config created");
const adapter = new PrismaMssql(sqlConfig);
console.log("Prisma MSSQL adapter created");
const prisma = new PrismaClient({ adapter });
console.log("Prisma Client created");

export { prisma };
