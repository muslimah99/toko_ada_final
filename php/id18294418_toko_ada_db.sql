-- phpMyAdmin SQL Dump
-- version 4.9.5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Feb 14, 2022 at 07:50 AM
-- Server version: 10.5.12-MariaDB
-- PHP Version: 7.3.32

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `id18294418_toko_ada_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_levels`
--

CREATE TABLE `tbl_levels` (
  `level_id` int(1) NOT NULL,
  `level_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_levels`
--

INSERT INTO `tbl_levels` (`level_id`, `level_name`) VALUES
(1, 'Admin'),
(2, 'Customer');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_order`
--

CREATE TABLE `tbl_order` (
  `order_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `product_quantity` int(11) NOT NULL,
  `order_date` datetime DEFAULT NULL,
  `order_status` varchar(30) NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_order`
--

INSERT INTO `tbl_order` (`order_id`, `user_id`, `product_id`, `product_quantity`, `order_date`, `order_status`, `payment_method`) VALUES
(1, 2, 26, 1, '2022-02-12 17:24:57', 'finished', 'Delivery & Transfer (BSI)'),
(2, 2, 2, 2, '2022-02-12 17:24:57', 'finished', 'Delivery & Transfer (BSI)'),
(3, 2, 23, 1, '2022-02-13 11:19:11', 'finished', 'Delivery & Transfer (BNI)'),
(4, 2, 22, 2, '2022-02-13 11:19:11', 'finished', 'Delivery & Transfer (BNI)'),
(5, 2, 6, 1, '2022-02-13 15:03:49', 'order sent', 'Take Away & Cash'),
(6, 2, 3, 1, '2022-02-13 15:03:49', 'order sent', 'Take Away & Cash'),
(7, 3, 6, 1, '2022-02-13 15:14:31', 'finished', 'Delivery & Transfer (BRI)');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_products`
--

CREATE TABLE `tbl_products` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(50) NOT NULL,
  `product_desc` text DEFAULT NULL,
  `product_price` double NOT NULL,
  `product_stock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_products`
--

INSERT INTO `tbl_products` (`product_id`, `product_name`, `product_desc`, `product_price`, `product_stock`) VALUES
(1, 'SEDAAP Mie Instan Korean Spicy Chicken Bag', 'Mie Instan Korean Spicy Chicken Bag', 2700, 5),
(2, 'SEDAAP Mie Singapore Spicy Laksa 83 gr', 'Mie Singapore Spicy Laksa 83 gr', 2600, 10),
(3, 'Bodyspray POSH Hijab Green Blossom 150ml', 'Bodyspray Hijab Green Blossom 150ml', 17400, 10),
(4, 'NUVO FAMILY Sabun Mandi Cair Mild Protect Pouch 45', 'Sabun Mandi Cair Mild Protect Pouch 450ml', 18500, 15),
(5, 'SUPERSOL Pembersih Lantai Karbol Pine 1800ml', 'Pembersih Lantai Karbol Pine 1800ml', 31600, 5),
(6, 'DAIA Deterjen Bubuk Bunga Bag', 'Deterjen Bubuk Bunga Bag 1.8 kg', 58200, 20),
(7, 'SOKLIN Pembersih Lantai Sereh/Lemongrass 780ml', 'Pembersih Lantai Sereh/Lemongrass 780ml', 11500, 10),
(8, 'SEDAAP Minyak Goreng Pouch 1L', 'Minyak Goreng Pouch 1L', 32800, 30),
(9, 'MAMA LIME GREEN TEA 780ml', 'Sabun cuci piring', 14700, 10),
(10, 'MILKU Susu UHT Susu Siap Minum Coklat Premium 200m', 'Susu UHT Susu Siap Minum Coklat Premium 200ml', 3500, 5),
(11, 'ROMA Kelapa 300 gram', 'Biskuit kelapa 300 gram', 10450, 5),
(12, 'SUPER BUBUR Buryam 10 Pcs berat 22 Gr', 'Bubur instan', 10000, 10),
(13, 'ROMA Sari Gandum Coklat 115 gr', 'Biskuit gandum Coklat 115 gr', 7500, 20),
(14, 'MIGELAS Ayam Bawang Renceng 10 Sachets 28 gr', 'Mi instan ukurna gelas', 14300, 10),
(15, 'SUPER BUBUR Ayam Single 45 Gram', 'Bubur instan', 3000, 15),
(16, 'KOPIKO Coffee Shot Classic Zak 150 gr 50 Pcs', 'Permen kopi', 7500, 20),
(17, 'KIS Apple Peach Zak 125 gram', 'Permen apel', 6200, 30),
(18, 'TEH PUCUK HARUM Jasmine 1360 ml', 'Minuman teh dalam botol', 12000, 50),
(19, 'ROMA Sandwich Cokelat 189 gram', 'Biskuit coklat', 8000, 35),
(20, 'ROMA Marie Gold 240 Gram', 'Biskuit Marie', 20000, 20),
(21, 'KAPAL API Special Mix 1 Renteng (10 x 24 gr)', 'Kopi seduh instan', 13225, 5),
(22, 'ABC Chocomalt RTD PET [200 ml]', 'Kopi instant', 2980, 10),
(23, 'GOOD DAY Cappuccino 1 Dus (5 x 25 gr)', 'Kopi rasa cappuccino', 10050, 10),
(24, 'RELAXA Lemon Mint 1 Bag (50 x 2.5 gr)', 'Permen Lemon Mint 1 Bag (50 x 2.5 gr)', 7300, 15),
(25, 'GOOD DAY Originale Cappuccino Ready To Drink 250 m', 'Kopi Cappuccino Ready To Drink 250 ml', 6475, 5),
(26, 'GOOD DAY Funtastic Mocacinno Ready To Drink', 'Kopi Mocacinno Ready To Drink 250 ml', 6475, 20),
(27, 'RELAXA Barley Mint 1 Bag (50 x 2.5 gr)', 'Perment mint', 7300, 10),
(28, 'ABC White Instant Coffee 1 Bag (20 x 20 gr)', 'Kopi Instant', 25900, 30);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `level_id` int(1) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_regdate` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `user_phone` varchar(15) DEFAULT NULL,
  `user_address` varchar(250) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `level_id`, `user_email`, `user_name`, `user_password`, `user_regdate`, `user_phone`, `user_address`) VALUES
(1, 1, 'suparlan@gmail.com', 'Asep Suparlan', 'c0a78b93a72c2a8f904e2807e443b8d1b0798c36', '2022-02-13 02:43:11', '082453686225', 'Toko Ada'),
(2, 2, 'munahanifatul99@gmail.com', 'Muna Hanifatul Muslimah', '17d51666d1062fde8fa415ac60dc9736375c3adb', '2022-02-12 11:18:06', '082457635698', 'RT 4, RW 8, Cirikip'),
(3, 2, 'muslimah@gmail.com', 'Muslimah', '1633acccb4cc9dd1aba83773a16b2504b597ad58', '2022-02-13 15:12:52', '082546879521', 'RT 1, RW 7, Cirikip');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_levels`
--
ALTER TABLE `tbl_levels`
  ADD PRIMARY KEY (`level_id`);

--
-- Indexes for table `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `tbl_products`
--
ALTER TABLE `tbl_products`
  ADD PRIMARY KEY (`product_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`),
  ADD KEY `level_id` (`level_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_order`
--
ALTER TABLE `tbl_order`
  MODIFY `order_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tbl_products`
--
ALTER TABLE `tbl_products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tbl_order`
--
ALTER TABLE `tbl_order`
  ADD CONSTRAINT `tbl_order_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `tbl_products` (`product_id`),
  ADD CONSTRAINT `tbl_order_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `tbl_users` (`user_id`);

--
-- Constraints for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD CONSTRAINT `tbl_users_ibfk_1` FOREIGN KEY (`level_id`) REFERENCES `tbl_levels` (`level_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
