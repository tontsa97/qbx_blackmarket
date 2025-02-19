CREATE TABLE IF NOT EXISTS `blackmarket_items` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(50) NOT NULL,
    `label` varchar(50) NOT NULL,
    `weight` int(11) NOT NULL DEFAULT 1,
    `can_remove` tinyint(1) NOT NULL DEFAULT 1,
    `unique` tinyint(1) NOT NULL DEFAULT 0,
    `description` text DEFAULT NULL,
    PRIMARY KEY (`id`)
);

INSERT INTO `blackmarket_items` VALUES
(1, 'trojan_usb', 'Trojan USB', 1, 1, 0, 'A USB device loaded with malicious software'),
(2, 'encrypted_phone', 'Encrypted Phone', 1, 1, 0, 'A secure communication device'),
(3, 'signal_jammer', 'Signal Jammer', 2, 1, 0, 'Disrupts nearby electronic signals'),
(4, 'keycard_clone', 'Cloned Keycard', 1, 1, 1, 'A perfect copy of a security keycard'),
(5, 'cutting_agent', 'Cutting Agent', 1, 1, 0, 'Used to increase drug quantity'),
(6, 'drug_supplies', 'Drug Lab Supplies', 2, 1, 0, 'Various supplies for drug production'),
(7, 'security_bypass', 'Security Bypass Module', 1, 1, 0, 'Advanced security bypassing tool'),
(8, 'vpn_device', 'VPN Device', 1, 1, 0, 'Secure network connection device'),
(9, 'crypto_miner', 'Crypto Mining Rig', 3, 1, 0, 'Hardware for mining cryptocurrency'),
(10, 'safe_cracker', 'Safe Cracking Tool', 2, 1, 0, 'Professional safe cracking equipment');