-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 09, 2025 at 01:41 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `capstone`
--

-- --------------------------------------------------------

--
-- Table structure for table `farmer`
--

CREATE TABLE `farmer` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `first_name` varchar(50) NOT NULL,
  `last_name` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `mobile` varchar(20) NOT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `sign_up_date` datetime DEFAULT current_timestamp(),
  `verification_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `farmer`
--

INSERT INTO `farmer` (`id`, `username`, `first_name`, `last_name`, `password`, `mobile`, `is_verified`, `sign_up_date`, `verification_date`) VALUES
(2, 'zandrix', 'zandrix', 'pongos', '$2y$10$xsm4ufHq77YguIqJvi4OSeGk0xjCd.MplGQELhKMv7HuU8c.jWBZa', '09304300733', 1, '2025-09-07 23:59:31', '2025-09-07 23:59:54'),
(3, 'bryan', 'bryan', 'altura', '$2y$10$2u6hsHSRrJI7J/ExZk.xJeBnm0z9dzQPyCqT1puh/YJUUdpwMf7rC', '09230939123912', 1, '2025-09-08 00:03:47', '2025-09-08 00:03:58'),
(4, 'hello', 'hello', 'hello', '$2y$10$ZVe8pVTuoqQLK3ZVSwVoY.jViSxNl7thwiA9635pmeqvV7oaxj7be', '123123123', 1, '2025-09-08 00:23:27', '2025-09-08 00:23:30'),
(5, 'hi', 'hi', 'hi', '$2y$10$fSjB626X7ive9teo/E.TV.BngMI17Vd4K8RTDfp4M0o2cqkc/xlki', '9239293912', 1, '2025-09-08 00:24:27', '2025-09-08 00:24:37'),
(6, 'awdaw', 'awd', 'awddaw', '$2y$10$5nuj5RakxzZNHdF3IAGg9erR/xnEnpQoyrOJmt6sb2c/2Ny/zDGyK', 'awdaw', 0, '2025-09-08 00:31:08', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `first_name`, `last_name`, `phone`, `password`) VALUES
(1, 'Zandrix', 'zandrix', 'pongos', '09304300733', '$2y$10$Wdkfq2txDn28pTsQE03vwepZEP/1uGxE254hEGXvOc9.sCSYzekYa');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `farmer`
--
ALTER TABLE `farmer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `farmer`
--
ALTER TABLE `farmer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
