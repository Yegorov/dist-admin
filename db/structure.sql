CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "login" varchar NOT NULL, "role" integer DEFAULT 2 NOT NULL, "banned" boolean DEFAULT 'f' NOT NULL, "deleted" boolean DEFAULT 'f' NOT NULL, "document_sequence" integer DEFAULT 0 NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "email" varchar DEFAULT '' NOT NULL, "encrypted_password" varchar DEFAULT '' NOT NULL, "reset_password_token" varchar, "reset_password_sent_at" datetime, "remember_created_at" datetime, "sign_in_count" integer DEFAULT 0 NOT NULL, "current_sign_in_at" datetime, "last_sign_in_at" datetime, "current_sign_in_ip" varchar, "last_sign_in_ip" varchar, "confirmation_token" varchar, "confirmed_at" datetime, "confirmation_sent_at" datetime, "unconfirmed_email" varchar, "failed_attempts" integer DEFAULT 0 NOT NULL, "unlock_token" varchar, "locked_at" datetime);
CREATE UNIQUE INDEX "index_users_on_login" ON "users" ("login");
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_reset_password_token" ON "users" ("reset_password_token");
CREATE UNIQUE INDEX "index_users_on_confirmation_token" ON "users" ("confirmation_token");
CREATE UNIQUE INDEX "index_users_on_unlock_token" ON "users" ("unlock_token");
CREATE TABLE "documents" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "iid" integer NOT NULL, "parent_iid" integer DEFAULT NULL, "owner_id" integer, "creator_id" integer, "type" varchar NOT NULL, "name" varchar NOT NULL, "real_path" varchar NOT NULL, "size" integer DEFAULT 0, "prepared" boolean DEFAULT 'f', "deleted" boolean DEFAULT 'f', "hash_sum" varchar DEFAULT '', "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_documents_on_owner_id" ON "documents" ("owner_id");
CREATE INDEX "index_documents_on_creator_id" ON "documents" ("creator_id");
CREATE TABLE "document_permissions" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "document_id" integer, "action" integer NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_document_permissions_on_user_id" ON "document_permissions" ("user_id");
CREATE INDEX "index_document_permissions_on_document_id" ON "document_permissions" ("document_id");
CREATE UNIQUE INDEX "idx_user_document_action" ON "document_permissions" ("user_id", "document_id", "action");
CREATE TABLE "document_action_logs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer, "document_id" integer, "action" integer, "message" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_document_action_logs_on_user_id" ON "document_action_logs" ("user_id");
CREATE INDEX "index_document_action_logs_on_document_id" ON "document_action_logs" ("document_id");
CREATE TABLE "tasks" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar DEFAULT '' NOT NULL, "state" integer DEFAULT 0 NOT NULL, "owner_id" integer, "started_at" datetime, "stopped_at" datetime, "finished_at" datetime, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_tasks_on_owner_id" ON "tasks" ("owner_id");
CREATE TABLE "task_logs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "state" integer, "task_id" integer, "message" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_task_logs_on_task_id" ON "task_logs" ("task_id");
CREATE TABLE "scripts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar NOT NULL, "owner_id" integer, "content" text DEFAULT '' NOT NULL, "mapper" text DEFAULT '' NOT NULL, "reducer" text DEFAULT '' NOT NULL, "input" text DEFAULT '' NOT NULL, "output" text DEFAULT '' NOT NULL, "language" integer DEFAULT 1 NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_scripts_on_owner_id" ON "scripts" ("owner_id");
INSERT INTO "schema_migrations" (version) VALUES
('20180222113745'),
('20180222114505'),
('20180223071308'),
('20180223093950'),
('20180223094239'),
('20180223203722'),
('20180223204300'),
('20180223205658');


