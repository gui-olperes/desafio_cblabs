CREATE DATABASE cb_labs_db;

USE cb_labs_db;


CREATE TABLE IF NOT EXISTS locations (
    loc_ref VARCHAR(50) PRIMARY KEY,
    loc_name VARCHAR(100) NOT NULL,
    -- Outros detalhes da loja podem ser adicionados aqui
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS guest_checks (
    guest_check_id BIGINT PRIMARY KEY,
    loc_ref VARCHAR(50) NOT NULL,
    chk_num INT NOT NULL,
    opn_bus_dt DATE,
    opn_utc TIMESTAMP,
    opn_lcl TIMESTAMP,
    clsd_bus_dt DATE,
    clsd_utc TIMESTAMP,
    clsd_lcl TIMESTAMP,
    last_trans_utc TIMESTAMP,
    last_trans_lcl TIMESTAMP,
    last_updated_utc TIMESTAMP,
    last_updated_lcl TIMESTAMP,
    clsd_flag BOOLEAN,
    gst_cnt INT,
    sub_ttl DECIMAL(10, 2),
    non_txbl_sls_ttl DECIMAL(10, 2),
    chk_ttl DECIMAL(10, 2),
    dsc_ttl DECIMAL(10, 2),
    pay_ttl DECIMAL(10, 2),
    bal_due_ttl DECIMAL(10, 2),
    rvc_num INT,
    ot_num INT,
    oc_num INT,
    tbl_num INT,
    tbl_name VARCHAR(100),
    emp_num INT,
    num_srvc_rd INT,
    num_chk_prntd INT,
    FOREIGN KEY (loc_ref) REFERENCES locations(loc_ref)
);

CREATE TABLE IF NOT EXISTS taxes (
    tax_id BIGINT AUTO_INCREMENT PRIMARY KEY, -- Ou SERIAL em PostgreSQL
    guest_check_id BIGINT NOT NULL,
    tax_num INT,
    txbl_sls_ttl DECIMAL(10, 2),
    tax_coll_ttl DECIMAL(10, 2),
    tax_rate DECIMAL(5, 2),
    type INT,
    FOREIGN KEY (guest_check_id) REFERENCES guest_checks(guest_check_id)
);

CREATE TABLE IF NOT EXISTS detail_lines (
    guest_check_line_item_id BIGINT PRIMARY KEY,
    guest_check_id BIGINT NOT NULL,
    line_item_type VARCHAR(50) NOT NULL, -- Indica o tipo de linha (e.g., 'menu_item', 'discount')
    dsp_ttl DECIMAL(10, 2),
    seat_num INT,
    rvc_num INT,
    dtl_ot_num INT,
    dtl_oc_num INT,
    line_num INT,
    dtl_id INT,
    detail_utc TIMESTAMP,
    detail_lcl TIMESTAMP,
    last_update_utc TIMESTAMP,
    last_update_lcl TIMESTAMP,
    bus_dt DATE,
    ws_num INT,
    agg_ttl DECIMAL(10, 2),
    agg_qty DECIMAL(10, 2),
    svc_rnd_num INT,
    chk_emp_id BIGINT,
    chk_emp_num INT,
    dsp_qty DECIMAL(10, 2),
    FOREIGN KEY (guest_check_id) REFERENCES guest_checks(guest_check_id)
);

CREATE TABLE IF NOT EXISTS menu_items (
    guest_check_line_item_id BIGINT PRIMARY KEY, -- Também é FK para detail_lines
    mi_num INT,
    mod_flag BOOLEAN,
    incl_tax DECIMAL(10, 2),
    active_taxes VARCHAR(255),
    prc_lvl INT,
    FOREIGN KEY (guest_check_line_item_id) REFERENCES detail_lines(guest_check_line_item_id)
);

CREATE TABLE IF NOT EXISTS discounts (
    guest_check_line_item_id BIGINT PRIMARY KEY,
    discount_code VARCHAR(50),
    discount_value DECIMAL(10, 2),
    FOREIGN KEY (guest_check_line_item_id) REFERENCES detail_lines(guest_check_line_item_id)
);

CREATE TABLE IF NOT EXISTS service_charges (
    guest_check_line_item_id BIGINT PRIMARY KEY,
    service_code VARCHAR(50),
    service_value DECIMAL(10, 2),
    FOREIGN KEY (guest_check_line_item_id) REFERENCES detail_lines(guest_check_line_item_id)
);

CREATE TABLE IF NOT EXISTS tender_media (
    guest_check_line_item_id BIGINT PRIMARY KEY,
    media_type VARCHAR(50),
    amount_paid DECIMAL(10, 2),
    FOREIGN KEY (guest_check_line_item_id) REFERENCES detail_lines(guest_check_line_item_id)
);

CREATE TABLE IF NOT EXISTS error_codes (
    guest_check_line_item_id BIGINT PRIMARY KEY,
    error_code VARCHAR(50),
    FOREIGN KEY (guest_check_line_item_id) REFERENCES detail_lines(guest_check_line_item_id)
);