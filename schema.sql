SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";

COMMENT ON SCHEMA "public" IS 'standard public schema';

CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";

CREATE EXTENSION IF NOT EXISTS "pg_jsonschema" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";

CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";

CREATE TYPE "public"."days" AS ENUM (
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
);

ALTER TYPE "public"."days" OWNER TO "postgres";

CREATE TYPE "public"."positions" AS ENUM (
    'Goalkeeper',
    'Defender',
    'Midfielder',
    'Forward'
);

ALTER TYPE "public"."positions" OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";

CREATE TABLE IF NOT EXISTS "public"."players" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "training_block_id" "uuid",
    "name" "text" DEFAULT ''::"text" NOT NULL,
    "number" numeric DEFAULT '99'::numeric NOT NULL,
    "position" "public"."positions" DEFAULT 'Goalkeeper'::"public"."positions" NOT NULL,
    "availabilities" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    CONSTRAINT "availabilities_schema" CHECK ("extensions"."jsonb_matches_schema"('{
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "day": {
            "type": "string",
            "enum": [
              "Monday",
              "Tuesday",
              "Wednesday",
              "Thursday",
              "Friday"
            ]
          },
          "start": {
            "type": "string"
          },
          "start_int": {
            "type": "number",
            "minimum": 0,
            "maximum": 1440
          },
          "end": {
            "type": "string"
          },
          "end_int": {
            "type": "number",
            "minimum": 0,
            "maximum": 1440
          }
        },
        "required": [
          "day",
          "start",
          "start_int",
          "end",
          "end_int"
        ]
      }
    }'::json, "availabilities"))
);

ALTER TABLE "public"."players" OWNER TO "postgres";

CREATE TABLE IF NOT EXISTS "public"."training_blocks" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "day" "public"."days" DEFAULT 'Monday'::"public"."days" NOT NULL,
    "start" "text" DEFAULT '8:00AM'::"text" NOT NULL,
    "start_int" numeric DEFAULT '480'::numeric NOT NULL,
    "end" "text" DEFAULT '8:30AM'::"text" NOT NULL,
    "end_int" numeric DEFAULT '510'::numeric NOT NULL
);

ALTER TABLE "public"."training_blocks" OWNER TO "postgres";

ALTER TABLE ONLY "public"."players"
    ADD CONSTRAINT "players_pkey" PRIMARY KEY ("id");

ALTER TABLE ONLY "public"."training_blocks"
    ADD CONSTRAINT "training_blocks_pkey" PRIMARY KEY ("id");

CREATE INDEX "players_training_block_id_idx" ON "public"."players" USING "btree" ("training_block_id");

ALTER TABLE ONLY "public"."players"
    ADD CONSTRAINT "players_training_block_id_fkey" FOREIGN KEY ("training_block_id") REFERENCES "public"."training_blocks"("id") ON UPDATE CASCADE ON DELETE SET NULL;

CREATE POLICY "Enable all access for all users" ON "public"."players" USING (true);

CREATE POLICY "Enable all access for all users" ON "public"."training_blocks" USING (true);

ALTER TABLE "public"."players" ENABLE ROW LEVEL SECURITY;

ALTER TABLE "public"."training_blocks" ENABLE ROW LEVEL SECURITY;

ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";

ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."players";

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON TABLE "public"."players" TO "anon";
GRANT ALL ON TABLE "public"."players" TO "authenticated";
GRANT ALL ON TABLE "public"."players" TO "service_role";

GRANT ALL ON TABLE "public"."training_blocks" TO "anon";
GRANT ALL ON TABLE "public"."training_blocks" TO "authenticated";
GRANT ALL ON TABLE "public"."training_blocks" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";

RESET ALL;
