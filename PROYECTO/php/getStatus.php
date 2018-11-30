<?php
	header('Access-Control-Allow-Origin: *');

	$headers = getallheaders();

	if( isset($headers['Auth']) && $headers['Auth'] == "mLctE2cOq3grtg9F" ){
		
		if(  isset($_POST['getStatusVoltaje']) ){
			require 'API_tmx.php';

			$objeto = new API_tmx();

			$result = $objeto->doQuery("SELECT vol, hr FROM volhumrel ORDER BY id LIMIT 1;");
			$json = json_encode($result);
			$jsonResp = [
				"ok" => "true",
				"description" => $json
			];
			echo json_encode($jsonResp);
			exit();
		}
		else{
			$jsonResp = [
				"ok" => "false",
				"description" => "Invalid params"
			];
			echo json_encode($jsonResp);
			exit();
		}
	}
	else{
		$jsonResp = [
			"ok" => "false",
			"description" => "Unauthorized"
		];
		echo json_encode($jsonResp);
		exit();
	}

?>