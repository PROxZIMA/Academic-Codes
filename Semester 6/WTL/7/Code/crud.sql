-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 03, 2022 at 11:40 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `crud`
--

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(6) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `lastname` varchar(30) NOT NULL,
  `email` varchar(70) NOT NULL,
  `course` varchar(30) NOT NULL,
  `batch` int(4) NOT NULL,
  `city` varchar(30) NOT NULL,
  `state` varchar(30) NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `firstname`, `lastname`, `email`, `course`, `batch`, `city`, `state`, `creation_date`) VALUES
(1, 'ashish', 'sharma', 'as_123@gmail.com', 'pgdca', 2013, 'ludhiana', 'punjab', '2022-03-11 11:04:37'),
(2, 'abhinav', 'kohli', 'abhinavk94@gmail.com', 'bca', 2014, 'dehradun', 'uttarakhand', '2022-02-26 07:08:18'),
(3, 'anjali', 'thakur', 'at123@gmail.com', 'mca', 2015, 'ambala', 'haryana', '2022-02-27 07:06:34'),
(4, 'aditi', 'goyal', 'aditi.xyz@gmail.com', 'bca', 2016, 'mohali', 'punjab', '2022-02-28 12:09:01'),
(5, 'keshav', 'kumar', 'kk123@gmail.com', 'mca', 2016, 'patna', 'bihar', '2022-02-28 12:10:42'),
(12, 'shweta', 'jain', 'sj.11293@yahoo.com', 'bca', 2017, 'shimla', 'himachal pradesh', '2022-03-13 09:28:25'),
(13, 'praveen', 'kumar', 'pv.94@yahoo.com', 'mca', 2017, 'patna', 'bihar', '2022-03-07 12:55:28'),
(14, 'suraj', 'chaudhary', 'sc.xyz@gmail.com', 'mca', 2018, 'sonipat', 'haryana', '2022-03-08 10:59:40'),
(19, 'ranjita', 'kumari', 'rk.9796@gmail.com', 'pdgca', 2019, 'patiala', 'punjab', '2022-03-12 08:14:34'),
(20, 'jagdeep', 'singh', 'js_xyz@gmail.com', 'bca', 2020, 'ludhiana', 'punjab', '2022-03-12 13:12:55');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
