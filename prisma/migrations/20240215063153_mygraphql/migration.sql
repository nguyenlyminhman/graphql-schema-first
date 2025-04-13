-- CreateEnum
CREATE TYPE "Permissions" AS ENUM ('ALL', 'CREATE', 'READ', 'UPDATE', 'DELETE');

-- AlterTable
ALTER TABLE "user" ADD COLUMN     "permissions" TEXT[];
