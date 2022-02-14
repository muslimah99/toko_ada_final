<?php
$servername = "localhost";
$username   = "id18294418_root";
$password   = "TBIkpENIpXq=LE9G";
$dbname     = "id18294418_toko_ada_db";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>