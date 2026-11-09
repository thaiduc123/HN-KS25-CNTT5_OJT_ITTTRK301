-- Tạo database app_db + bảng items + dữ liệu mẫu.
-- Cách chạy bằng MySQL Workbench:
--   File > Open SQL Script... > chọn file này > bấm nút tia sét (Execute) > Refresh ô SCHEMAS.
-- Chạy lại nhiều lần không lỗi (đã có thì bỏ qua), chỉ là dữ liệu mẫu sẽ bị thêm lặp.

SET NAMES utf8mb4; -- để tiếng Việt không bị lỗi font

CREATE DATABASE IF NOT EXISTS app_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE app_db;

CREATE TABLE IF NOT EXISTS items (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(255) NOT NULL,
  description TEXT NULL,
  price       DECIMAL(12, 2) NOT NULL DEFAULT 0,
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO items (name, description, price) VALUES
  ('Cơm rang dưa bò', 'Món mẫu để kiểm tra API', 45000),
  ('Trà đá', 'Dữ liệu mẫu số 2', 5000);

-- Món ăn.
CREATE TABLE IF NOT EXISTS dishes (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  category_id  INT NOT NULL,
  name         VARCHAR(255) NOT NULL,
  description  TEXT NULL,
  price        DECIMAL(12, 2) NOT NULL DEFAULT 0,
  image        VARCHAR(500) NULL,
  status       VARCHAR(20) NOT NULL DEFAULT 'ĐANG BÁN',
  is_featured  BOOLEAN NOT NULL DEFAULT FALSE,
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY uq_dishes_category_name (category_id, name),
  CONSTRAINT fk_dishes_category
    FOREIGN KEY (category_id) REFERENCES categories(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tuỳ chọn của món ăn: size, topping...
CREATE TABLE IF NOT EXISTS dish_options (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  dish_id      INT NOT NULL,
  group_name   VARCHAR(100) NOT NULL,
  name         VARCHAR(100) NOT NULL,
  price_extra  DECIMAL(12, 2) NOT NULL DEFAULT 0,
  is_required  BOOLEAN NOT NULL DEFAULT FALSE,
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_dish_options (dish_id, group_name, name),
  CONSTRAINT fk_dish_options_dish
    FOREIGN KEY (dish_id) REFERENCES dishes(id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dữ liệu mẫu cho bảng items cũ.
INSERT IGNORE INTO items (id, name, description, price) VALUES
  (1, 'Cơm rang dưa bò', 'Món mẫu để kiểm tra API', 45000),
  (2, 'Trà đá', 'Dữ liệu mẫu số 2', 5000);

-- 6 danh mục.
INSERT IGNORE INTO categories (id, name, sort_order, is_active) VALUES
  (1, 'Cơm', 1, TRUE),
  (2, 'Bún - Phở', 2, TRUE),
  (3, 'Mì', 3, TRUE),
  (4, 'Đồ ăn nhanh', 4, TRUE),
  (5, 'Đồ uống', 5, TRUE),
  (6, 'Tráng miệng', 6, TRUE);

-- 30 món ăn: mỗi danh mục có 5 món.
INSERT IGNORE INTO dishes
  (id, category_id, name, description, price, image, status, is_featured)
VALUES
  (1, 1, 'Cơm rang dưa bò', 'Cơm rang cùng dưa chua và thịt bò', 45000, NULL, 'ĐANG BÁN', TRUE),
  (2, 1, 'Cơm gà xối mỡ', 'Cơm ăn kèm đùi gà chiên giòn', 50000, NULL, 'ĐANG BÁN', TRUE),
  (3, 1, 'Cơm sườn nướng', 'Cơm trắng ăn cùng sườn nướng', 45000, NULL, 'ĐANG BÁN', FALSE),
  (4, 1, 'Cơm thịt kho trứng', 'Thịt kho mềm cùng trứng và cơm trắng', 40000, NULL, 'ĐANG BÁN', FALSE),
  (5, 1, 'Cơm bò lúc lắc', 'Thịt bò xào rau củ ăn cùng cơm', 55000, NULL, 'ĐANG BÁN', TRUE),

  (6, 2, 'Phở bò tái', 'Phở nước dùng bò, thịt bò tái', 45000, NULL, 'ĐANG BÁN', TRUE),
  (7, 2, 'Phở bò chín', 'Phở bò với thịt bò chín', 45000, NULL, 'ĐANG BÁN', FALSE),
  (8, 2, 'Bún chả Hà Nội', 'Bún ăn cùng chả nướng và nước chấm', 50000, NULL, 'ĐANG BÁN', TRUE),
  (9, 2, 'Bún bò Huế', 'Bún nước dùng đậm đà, thịt bò', 50000, NULL, 'ĐANG BÁN', TRUE),
  (10, 2, 'Bún nem rán', 'Bún ăn cùng nem rán và rau sống', 40000, NULL, 'ĐANG BÁN', FALSE),

  (11, 3, 'Mì xào bò', 'Mì xào cùng thịt bò và rau củ', 45000, NULL, 'ĐANG BÁN', TRUE),
  (12, 3, 'Mì xào hải sản', 'Mì xào tôm, mực và rau củ', 55000, NULL, 'ĐANG BÁN', FALSE),
  (13, 3, 'Mì Ý sốt bò bằm', 'Mì Ý với sốt cà chua và bò bằm', 60000, NULL, 'ĐANG BÁN', TRUE),
  (14, 3, 'Mì cay hải sản', 'Mì cay cùng tôm, mực và xúc xích', 55000, NULL, 'ĐANG BÁN', FALSE),
  (15, 3, 'Mì trộn xúc xích', 'Mì trộn sốt đặc biệt và xúc xích', 35000, NULL, 'ĐANG BÁN', FALSE),

  (16, 4, 'Hamburger bò', 'Bánh mì kẹp thịt bò và rau', 45000, NULL, 'ĐANG BÁN', TRUE),
  (17, 4, 'Gà rán 2 miếng', 'Hai miếng gà chiên giòn', 55000, NULL, 'ĐANG BÁN', TRUE),
  (18, 4, 'Khoai tây chiên', 'Khoai tây chiên giòn', 25000, NULL, 'ĐANG BÁN', FALSE),
  (19, 4, 'Xúc xích chiên', 'Xúc xích chiên ăn kèm tương', 20000, NULL, 'ĐANG BÁN', FALSE),
  (20, 4, 'Pizza mini', 'Pizza cỡ nhỏ phô mai và xúc xích', 50000, NULL, 'ĐANG BÁN', TRUE),

  (21, 5, 'Trà đá', 'Trà đá mát lạnh', 5000, NULL, 'ĐANG BÁN', FALSE),
  (22, 5, 'Trà chanh', 'Trà chanh tươi', 15000, NULL, 'ĐANG BÁN', TRUE),
  (23, 5, 'Trà đào', 'Trà đào cam sả', 25000, NULL, 'ĐANG BÁN', TRUE),
  (24, 5, 'Cà phê sữa', 'Cà phê pha cùng sữa', 20000, NULL, 'ĐANG BÁN', FALSE),
  (25, 5, 'Nước cam', 'Nước cam ép tươi', 25000, NULL, 'ĐANG BÁN', FALSE),

  (26, 6, 'Chè khúc bạch', 'Chè khúc bạch hạnh nhân', 25000, NULL, 'ĐANG BÁN', TRUE),
  (27, 6, 'Rau câu dừa', 'Rau câu vị dừa', 15000, NULL, 'ĐANG BÁN', FALSE),
  (28, 6, 'Sữa chua mít', 'Sữa chua ăn cùng mít và thạch', 25000, NULL, 'ĐANG BÁN', TRUE),
  (29, 6, 'Flan caramel', 'Bánh flan mềm vị caramel', 12000, NULL, 'ĐANG BÁN', FALSE),
  (30, 6, 'Kem vani', 'Kem vani mát lạnh', 20000, NULL, 'ĐANG BÁN', FALSE);

-- Một số tuỳ chọn mẫu cho món ăn.
INSERT IGNORE INTO dish_options
  (id, dish_id, group_name, name, price_extra, is_required)
VALUES
  (1, 1, 'Thêm món', 'Thêm trứng', 7000, FALSE),
  (2, 1, 'Thêm món', 'Thêm thịt bò', 15000, FALSE),
  (3, 2, 'Thêm món', 'Thêm đùi gà', 25000, FALSE),
  (4, 6, 'Chọn loại thịt', 'Bò tái', 0, TRUE),
  (5, 6, 'Chọn loại thịt', 'Bò chín', 0, TRUE),
  (6, 9, 'Chọn mức cay', 'Ít cay', 0, TRUE),
  (7, 9, 'Chọn mức cay', 'Cay vừa', 0, TRUE),
  (8, 9, 'Chọn mức cay', 'Cay nhiều', 0, TRUE),
  (9, 16, 'Thêm topping', 'Thêm phô mai', 10000, FALSE),
  (10, 17, 'Thêm món', 'Thêm 1 miếng gà', 25000, FALSE),
  (11, 22, 'Chọn size', 'Size L', 5000, TRUE),
  (12, 23, 'Chọn size', 'Size L', 7000, TRUE),
  (13, 24, 'Chọn size', 'Size L', 5000, TRUE),
  (14, 30, 'Thêm topping', 'Thêm socola', 5000, FALSE);
