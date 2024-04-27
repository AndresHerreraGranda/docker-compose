-- Create data base
CREATE DATABASE pricddb;

-- Connection to database
\c pricddb;

-- Create schema if not exists
CREATE SCHEMA IF NOT EXISTS pricing;

-- Set search_path to the schema
SET search_path TO pricing;

-- Create sequence for id
CREATE SEQUENCE neg_id_seq;
-- Table Average_monthly_commission
CREATE TABLE IF NOT EXISTS average_monthly_commission
(
    id_commission      SERIAL      NOT NULL,
    input_flow         VARCHAR(45) NULL,
    payment_dispersion VARCHAR(45) NULL,
    PRIMARY KEY (id_commission)
);

-- Table Average_monthly_flow
CREATE TABLE IF NOT EXISTS average_monthly_flow
(
    id_flow                        SERIAL      NOT NULL,
    input_flow                     VARCHAR(45) NULL,
    bancolombia_account_dispersion VARCHAR(45) NULL,
    ACH_bank_dispersion            VARCHAR(45) NULL,
    PRIMARY KEY (id_flow)
);

-- Table Average_monthly_transactions
CREATE TABLE IF NOT EXISTS average_monthly_transactions
(
    id_transactions    SERIAL      NOT NULL,
    input_flows        VARCHAR(45) NULL,
    payment_dispersion VARCHAR(45) NULL,
    payroll_dispersion VARCHAR(45) NULL,
    PRIMARY KEY (id_transactions)
);

-- Table Average_monthly_balance
CREATE TABLE IF NOT EXISTS average_monthly_balance
(
    id_balance           SERIAL      NOT NULL,
    savings_accounts     VARCHAR(45) NULL,
    current_accounts     VARCHAR(45) NULL,
    terms_deposits_CDT   VARCHAR(45) NULL,
    virtual_investment   VARCHAR(45) NULL,
    commercial_portfolio VARCHAR(45) NULL,
    factoring_portfolio  VARCHAR(45) NULL,
    payroll_portfolio    VARCHAR(45) NULL,
    PRIMARY KEY (id_balance)
);

-- Table Policy
CREATE TABLE IF NOT EXISTS policy
(
    id_policy          SERIAL      NOT NULL,
    customer_type      VARCHAR(45) NULL,
    portfolio_type     VARCHAR(45) NULL,
    input_flow_product VARCHAR(45) NULL,
    id_commission      INT         NULL,
    id_flow            INT         NULL,
    id_transactions    INT         NULL,
    id_balance         INT         NULL,
    PRIMARY KEY (id_policy),
    CONSTRAINT fk_Policy_commission
        FOREIGN KEY (id_commission)
            REFERENCES average_monthly_commission (id_commission)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_Policy_flow
        FOREIGN KEY (id_flow)
            REFERENCES average_monthly_flow (id_flow)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_Policy_transactions
        FOREIGN KEY (id_transactions)
            REFERENCES average_monthly_transactions (id_transactions)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_Policy_balance
        FOREIGN KEY (id_balance)
            REFERENCES average_monthly_balance (id_balance)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

-- Table Quote
CREATE TABLE IF NOT EXISTS quote
(
    id_quote             VARCHAR(20)                 DEFAULT 'NEG' || nextval('neg_id_seq')::TEXT PRIMARY KEY,
    creator_user         VARCHAR(45)                                           NULL,
    creator_role         VARCHAR(45)                                           NULL,
    version_policy       VARCHAR(45)                                           NULL,
    version_quote        VARCHAR(45)                                           NULL,
    creation_date        TIMESTAMP(0) WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NULL,
    modification_date    TIMESTAMP(0) WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NULL,
    deleted_at           TIMESTAMP(0) WITH TIME ZONE                           NULL,
    money                VARCHAR(45)                                           NULL,
    negotiation_level_of VARCHAR(45)                                           NULL,
    state                VARCHAR(45)                                           NULL,
    negotiated_document  VARCHAR(45)                                           NULL,
    id_policy            INT                                                   NULL,
    CONSTRAINT fk_Quote_Policy1
        FOREIGN KEY (id_policy)
            REFERENCES Policy (id_policy)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

-- Table Customer
CREATE TABLE IF NOT EXISTS customer
(
    id_customer      SERIAL       NOT NULL,
    name             VARCHAR(255) NULL,
    document_type    VARCHAR(45)  NULL,
    document_number  VARCHAR(45)  NULL,
    segment          VARCHAR(45)  NULL,
    risk_rating      VARCHAR(45)  NULL,
    subsidiary       VARCHAR(45)  NULL,
    manager          VARCHAR(45)  NULL,
    relationship     VARCHAR(45)  NULL,
    relationship_nit VARCHAR(45)  NULL,
    credit_strategy  VARCHAR(45)  NULL,
    PRIMARY KEY (id_customer)
);

-- Table Economic_group
CREATE TABLE IF NOT EXISTS economic_group
(
    id_economic_group SERIAL      NOT NULL,
    name              VARCHAR(45) NULL,
    document_number   VARCHAR(45) NULL,
    id_customer       INT         NULL,
    PRIMARY KEY (id_economic_group),
    CONSTRAINT fk_Customer_Economic_group
        FOREIGN KEY (id_customer)
            REFERENCES Customer (id_customer)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

-- Table Quote_detail
CREATE TABLE IF NOT EXISTS quote_detail
(
    id_quote_detail                      SERIAL           NOT NULL,
    current_tariff                       DOUBLE PRECISION NULL,
    full_tariff                          DOUBLE PRECISION NULL,
    suggested_tariff                     DOUBLE PRECISION NULL,
    negotiated_tariff                    DOUBLE PRECISION NULL,
    tariff_difference                    DOUBLE PRECISION NULL,
    negotiated_rate_discount             DOUBLE PRECISION NULL,
    negotiated_rate_exemption_percentage DOUBLE PRECISION NULL,
    current_transactions                 DOUBLE PRECISION NULL,
    new_transactions                     DOUBLE PRECISION NULL,
    transaction_variation                DOUBLE PRECISION NULL,
    current_income                       DOUBLE PRECISION NULL,
    new_income                           DOUBLE PRECISION NULL,
    current_gcar                         DOUBLE PRECISION NULL,
    new_gcar                             DOUBLE PRECISION NULL,
    current_roe                          DOUBLE PRECISION NULL,
    new_roe                              DOUBLE PRECISION NULL,
    currency                             VARCHAR(45)      NULL,
    term_type                            VARCHAR(45)      NULL,
    term                                 DOUBLE PRECISION NULL,
    average_ticket                       DOUBLE PRECISION NULL,
    suggested_rate_exemption_percentage  DOUBLE PRECISION NULL,
    current_rate_exemption_percentage    DOUBLE PRECISION NULL,
    commercial_position                  VARCHAR(45)      NULL,
    entity                               VARCHAR(45)      NULL,
    new_sale_renegotiation               VARCHAR(45)      NULL,
    id_quote                             VARCHAR          NULL,
    product_type_id                      INT              NULL,
    product_type_name                    VARCHAR(20)      NULL,
    id_product                           INT              NULL,
    product_name                         VARCHAR(100)     NULL,
    capture_method_id                    INT              NULL,
    capture_method_name                  VARCHAR(70)      NULL,
    channel_id                           INT              NULL,
    channel_name                         VARCHAR(50)      NULL,
    PRIMARY KEY (id_quote_detail),
    CONSTRAINT fk_Quote_detail_Quote
        FOREIGN KEY (id_quote)
            REFERENCES Quote (id_quote)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

-- Table Quote_customer
CREATE TABLE IF NOT EXISTS quote_customer
(
    id_quote_customer SERIAL  NOT NULL,
    id_customer       INT     NULL,
    id_quote          VARCHAR NULL,
    PRIMARY KEY (id_quote_customer),
    CONSTRAINT fk_Quote_customer_Customer
        FOREIGN KEY (id_customer)
            REFERENCES Customer (id_customer)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION,
    CONSTRAINT fk_Quote_customer_Quote
        FOREIGN KEY (id_quote)
            REFERENCES Quote (id_quote)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);

-- Table Quote_profitability_simulated_products
CREATE TABLE IF NOT EXISTS profitability_simulated_products
(
    id_simulated_products SERIAL           NOT NULL,
    product               VARCHAR(100)     NULL,
    current_gcar           DOUBLE PRECISION NULL,
    current_roe            DOUBLE PRECISION NULL,
    new_gcar              DOUBLE PRECISION NULL,
    new_roe               DOUBLE PRECISION NULL,
    id_quote              VARCHAR          NULL,
    PRIMARY KEY (id_simulated_products),
    CONSTRAINT fk_Quote_detail_Quote
        FOREIGN KEY (id_quote)
            REFERENCES Quote (id_quote)
            ON DELETE NO ACTION
            ON UPDATE NO ACTION
);
