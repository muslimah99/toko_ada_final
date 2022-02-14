<?php
	include_once("dbconnect.php");

	$userid = $_POST['userid'];

	$sql = "SELECT * FROM tbl_order INNER JOIN tbl_products ON tbl_order.product_id = tbl_products.product_id WHERE user_id = $userid AND order_status = 'in the cart'";
	$result = $conn->query($sql);

	if ($result->num_rows > 0) {
    	$products["products"] = array();
		while ($row = $result->fetch_assoc()) {
	        $prlist = array();
	        $prlist['orid'] = $row['order_id'];
	        $prlist['prid'] = $row['product_id'];
	        $prlist['prname'] = $row['product_name'];
	        $prlist['prprice'] = $row['product_price'];
	        $prlist['prqntty'] = $row['product_quantity'];
	        $prlist['prstock'] = $row['product_stock'];

	        array_push($products["products"],$prlist);
	    }
	    $response = array('status' => 'success', 'data' => $products);
	    sendJsonResponse($response);
	} else{
	    $response = array('status' => 'failed', 'data' => null);
	    sendJsonResponse($response);
	}

	function sendJsonResponse($sentArray)
	{
	    header('Content-Type: application/json');
	    echo json_encode($sentArray);
	}
?>