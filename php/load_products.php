<?php
	include_once("dbconnect.php");

	$sql = "SELECT * FROM tbl_products ORDER BY product_name ASC";
	$result = $conn->query($sql);

	if ($result->num_rows > 0) {
    	$products["products"] = array();
		while ($row = $result->fetch_assoc()) {
	        $prlist = array();
	        $prlist['prid'] = $row['product_id'];
	        $prlist['prname'] = $row['product_name'];
	        $prlist['prdesc'] = $row['product_desc'];
	        $prlist['prprice'] = $row['product_price'];
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