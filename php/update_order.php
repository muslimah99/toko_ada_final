<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['ordstatus'])) {
    $ordstatus = $_POST['ordstatus'];
    $userid = $_POST['userid'];

    if($ordstatus == "in the cart") {
        $prid = $_POST['prid'];
        $prqntty = $_POST['prqntty'];

        $sql = "INSERT INTO tbl_order (user_id, product_id, product_quantity, order_status) VALUES($userid,'$prid','$prqntty','$ordstatus')";

    } else if ($ordstatus == "order sent") {
        $payment_method = $_POST['payment_method'];

        if(isset($_POST['cash']) || $payment_method == "Delivery & Transfer") {

            $sql = "UPDATE tbl_order SET order_date = NOW(), order_status = '$ordstatus', payment_method = '$payment_method' WHERE user_id = '$userid' AND order_status = 'in the cart'";

        } else {

            $sql = "UPDATE tbl_order SET payment_method = '$payment_method' WHERE user_id = '$userid' AND payment_method = 'Delivery & Transfer'";    

        }
    } else {
        $ordate = $_POST['ordate'];
        $sql = "UPDATE tbl_order SET order_status = '$ordstatus' WHERE user_id = '$userid' AND order_date = '$ordate'";    

    }
}

if (isset($_POST['orid'])) {
    $orid = $_POST['orid'];
    if (isset($_POST['prqntty'])) {
        $prqntty = $_POST['prqntty'];

        $sql = "UPDATE tbl_order SET product_quantity = '$prqntty' WHERE order_id = '$orid'";

    } else {
        
        $sql = "DELETE FROM tbl_order WHERE order_id = '$orid'";
    }
}

if ($conn->query($sql) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>