<?php
	include_once("dbconnect.php");
	
	$order = $_POST['order'];

	if($order == "order detail") {
		$userid = $_POST['userid'];
		$sql = "SELECT * FROM tbl_order INNER JOIN tbl_products ON tbl_order.product_id = tbl_products.product_id WHERE user_id = $userid AND order_date IS NOT NULL ORDER BY order_date DESC";
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
		        $prlist['ordstatus'] = $row['order_status'];
		        $prlist['payment_method'] = $row['payment_method'];
		        $prlist['ordate'] = $row['order_date'];
		        array_push($products["products"],$prlist);
		    }
		    $response = array('status' => 'success', 'data' => $products);
		    sendJsonResponse($response);
		} else{
		    $response = array('status' => 'failed', 'data' => null);
		    sendJsonResponse($response);
		}

	} else {

		$sql = "SELECT * FROM tbl_users";
		$result = $conn->query($sql);

		if ($result->num_rows > 0) {
	    	$users["users"] = array();
			while ($row = $result->fetch_assoc()) {
		        $userlist = array();
		        $userlist['userid'] = $row['user_id'];
		        $userlist['uname'] = $row['user_name'];
		        $userlist['address'] = $row['user_address'];
		        $userid = $userlist['userid'];
		        $sql2 = "SELECT * FROM tbl_users INNER JOIN tbl_order ON tbl_users.user_id = tbl_order.user_id WHERE tbl_order.user_id = '$userid'";
				$result2 = $conn->query($sql2);

				if ($result2->num_rows > 0) {
					array_push($users["users"], $userlist);
				}
		    }
		    $response = array('status' => 'success', 'data' => $users);
		    sendJsonResponse($response);
		} else {
		    $response = array('status' => 'failed', 'data' => null);
		    sendJsonResponse($response);
		}
	}

	function sendJsonResponse($sentArray)
	{
	    header('Content-Type: application/json');
	    echo json_encode($sentArray);
	}
?>