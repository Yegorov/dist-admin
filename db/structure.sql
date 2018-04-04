SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: document_action_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE document_action_logs (
    id bigint NOT NULL,
    user_id bigint,
    document_id bigint,
    action integer,
    message character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: document_action_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE document_action_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_action_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE document_action_logs_id_seq OWNED BY document_action_logs.id;


--
-- Name: document_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE document_permissions (
    id bigint NOT NULL,
    user_id bigint,
    document_id bigint,
    action integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: document_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE document_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: document_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE document_permissions_id_seq OWNED BY document_permissions.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE documents (
    id bigint NOT NULL,
    iid integer NOT NULL,
    parent_iid integer,
    owner_id bigint,
    creator_id bigint,
    type character varying NOT NULL,
    name character varying NOT NULL,
    real_path character varying NOT NULL,
    size integer DEFAULT 0,
    prepared boolean DEFAULT false,
    deleted boolean DEFAULT false,
    hash_sum character varying DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE documents_id_seq OWNED BY documents.id;


--
-- Name: encryptors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE encryptors (
    id bigint NOT NULL,
    document_id bigint,
    cipher character varying,
    pass_phrase_hash character varying,
    pass_phrase_salt character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: encryptors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE encryptors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: encryptors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE encryptors_id_seq OWNED BY encryptors.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: scripts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE scripts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    owner_id bigint,
    description text DEFAULT ''::text NOT NULL,
    mapper text DEFAULT ''::text NOT NULL,
    reducer text DEFAULT ''::text NOT NULL,
    input text DEFAULT ''::text NOT NULL,
    output text DEFAULT ''::text NOT NULL,
    language integer DEFAULT 1 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: scripts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE scripts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scripts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE scripts_id_seq OWNED BY scripts.id;


--
-- Name: task_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE task_logs (
    id bigint NOT NULL,
    state integer,
    task_id bigint,
    message character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: task_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE task_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: task_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE task_logs_id_seq OWNED BY task_logs.id;


--
-- Name: tasks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE tasks (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    state integer DEFAULT 0 NOT NULL,
    prepared boolean DEFAULT true NOT NULL,
    owner_id bigint,
    script_id bigint,
    started_at timestamp without time zone,
    stopped_at timestamp without time zone,
    finished_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tasks_id_seq OWNED BY tasks.id;


--
-- Name: upload_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE upload_files (
    id bigint NOT NULL,
    file_name character varying DEFAULT 'file'::character varying NOT NULL,
    size integer DEFAULT 0 NOT NULL,
    current_size integer DEFAULT 0 NOT NULL,
    path character varying NOT NULL,
    user_id bigint,
    unique_id character varying NOT NULL,
    "to" character varying DEFAULT 'root'::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: upload_files_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE upload_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: upload_files_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE upload_files_id_seq OWNED BY upload_files.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id bigint NOT NULL,
    name character varying,
    login character varying NOT NULL,
    role integer DEFAULT 2 NOT NULL,
    banned boolean DEFAULT false NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    public boolean DEFAULT false NOT NULL,
    document_sequence integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: document_action_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_action_logs ALTER COLUMN id SET DEFAULT nextval('document_action_logs_id_seq'::regclass);


--
-- Name: document_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_permissions ALTER COLUMN id SET DEFAULT nextval('document_permissions_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents ALTER COLUMN id SET DEFAULT nextval('documents_id_seq'::regclass);


--
-- Name: encryptors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY encryptors ALTER COLUMN id SET DEFAULT nextval('encryptors_id_seq'::regclass);


--
-- Name: scripts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY scripts ALTER COLUMN id SET DEFAULT nextval('scripts_id_seq'::regclass);


--
-- Name: task_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_logs ALTER COLUMN id SET DEFAULT nextval('task_logs_id_seq'::regclass);


--
-- Name: tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks ALTER COLUMN id SET DEFAULT nextval('tasks_id_seq'::regclass);


--
-- Name: upload_files id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY upload_files ALTER COLUMN id SET DEFAULT nextval('upload_files_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: document_action_logs document_action_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_action_logs
    ADD CONSTRAINT document_action_logs_pkey PRIMARY KEY (id);


--
-- Name: document_permissions document_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_permissions
    ADD CONSTRAINT document_permissions_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: encryptors encryptors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY encryptors
    ADD CONSTRAINT encryptors_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: scripts scripts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY scripts
    ADD CONSTRAINT scripts_pkey PRIMARY KEY (id);


--
-- Name: task_logs task_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_logs
    ADD CONSTRAINT task_logs_pkey PRIMARY KEY (id);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: upload_files upload_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY upload_files
    ADD CONSTRAINT upload_files_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_user_document_action; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_user_document_action ON document_permissions USING btree (user_id, document_id, action);


--
-- Name: index_document_action_logs_on_document_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_document_action_logs_on_document_id ON document_action_logs USING btree (document_id);


--
-- Name: index_document_action_logs_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_document_action_logs_on_user_id ON document_action_logs USING btree (user_id);


--
-- Name: index_document_permissions_on_document_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_document_permissions_on_document_id ON document_permissions USING btree (document_id);


--
-- Name: index_document_permissions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_document_permissions_on_user_id ON document_permissions USING btree (user_id);


--
-- Name: index_documents_on_creator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_creator_id ON documents USING btree (creator_id);


--
-- Name: index_documents_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_owner_id ON documents USING btree (owner_id);


--
-- Name: index_encryptors_on_document_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_encryptors_on_document_id ON encryptors USING btree (document_id);


--
-- Name: index_scripts_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_scripts_on_owner_id ON scripts USING btree (owner_id);


--
-- Name: index_task_logs_on_task_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_task_logs_on_task_id ON task_logs USING btree (task_id);


--
-- Name: index_tasks_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_owner_id ON tasks USING btree (owner_id);


--
-- Name: index_tasks_on_script_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tasks_on_script_id ON tasks USING btree (script_id);


--
-- Name: index_upload_files_on_unique_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_upload_files_on_unique_id ON upload_files USING btree (unique_id);


--
-- Name: index_upload_files_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_upload_files_on_user_id ON upload_files USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_login; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_login ON users USING btree (login);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON users USING btree (unlock_token);


--
-- Name: document_permissions fk_rails_1ccbff8550; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_permissions
    ADD CONSTRAINT fk_rails_1ccbff8550 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: document_permissions fk_rails_219008edb6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY document_permissions
    ADD CONSTRAINT fk_rails_219008edb6 FOREIGN KEY (document_id) REFERENCES users(id);


--
-- Name: tasks fk_rails_5061123da3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT fk_rails_5061123da3 FOREIGN KEY (script_id) REFERENCES scripts(id) ON DELETE SET NULL;


--
-- Name: documents fk_rails_75a29a42d4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT fk_rails_75a29a42d4 FOREIGN KEY (creator_id) REFERENCES users(id);


--
-- Name: tasks fk_rails_877a66d795; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT fk_rails_877a66d795 FOREIGN KEY (owner_id) REFERENCES users(id);


--
-- Name: encryptors fk_rails_9737e87569; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY encryptors
    ADD CONSTRAINT fk_rails_9737e87569 FOREIGN KEY (document_id) REFERENCES documents(id);


--
-- Name: scripts fk_rails_99420e52f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY scripts
    ADD CONSTRAINT fk_rails_99420e52f9 FOREIGN KEY (owner_id) REFERENCES users(id);


--
-- Name: task_logs fk_rails_a7d8cfaf20; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY task_logs
    ADD CONSTRAINT fk_rails_a7d8cfaf20 FOREIGN KEY (task_id) REFERENCES tasks(id);


--
-- Name: documents fk_rails_d57828d9bc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY documents
    ADD CONSTRAINT fk_rails_d57828d9bc FOREIGN KEY (owner_id) REFERENCES users(id);


--
-- Name: upload_files fk_rails_da06925a99; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY upload_files
    ADD CONSTRAINT fk_rails_da06925a99 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180222113745'),
('20180222114505'),
('20180223071308'),
('20180223093950'),
('20180223094239'),
('20180223203722'),
('20180223204300'),
('20180223205658'),
('20180321085307'),
('20180403111538');


