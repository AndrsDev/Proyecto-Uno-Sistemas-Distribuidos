<?php
    $transactions_path = "transactions.txt";
    $balances_path = "balances.txt";

    //Read the previous lines of the file
    $balances = array();
    $transactions_file = fopen($transactions_path, "r");
    while(!feof($transactions_file)){
        $line = fgets($transactions_file);
        $arr = explode(",", $line);

        if (!isset($arr[1])) { $arr[1] = null; }
        if (!isset($arr[2])) { $arr[2] = null; }
        if (!isset($arr[3])) { $arr[3] = null; }
        if (!isset($arr[4])) { $arr[4] = null; }
        if (!isset($arr[5])) { $arr[5] = null; }
        if (!isset($arr[6])) { $arr[6] = null; }

        $id = $arr[1];
        $name = $arr[2];
        $last_name = $arr[3];
        $type = $arr[4];
        $updated = $arr[5];

        if($type == 'credito'){
            $amount = floatval($arr[6]);
        } else {
            $amount = floatval($arr[6]) * -1;
        }
       
        if(!isset($balances[$id])){
            if (!isset($balances[$id]['id'])) { $balances[$id]['id'] = $id; }
            if (!isset($balances[$id]['name'])) { $balances[$id]['name'] = $name; }
            if (!isset($balances[$id]['last_name'])) { $balances[$id]['last_name'] = $last_name; }
            if (!isset($balances[$id]['updated'])) { $balances[$id]['updated'] = $updated; }
            if (!isset($balances[$id]['total'])) { $balances[$id]['total'] = $amount; }
        } else {
            $balances[$id]['updated'] = $updated;
            $balances[$id]['total'] += $amount;
        }

    }
    fclose($transactions_file);


    $balances_file = fopen($balances_path, "w") or die("Unable to open file!");

    foreach ($balances as $row) {
        $line = $row['id'] . "," . $row['name'] . "," . $row['last_name'] . "," . $row['updated'] . "," . $row['total'] . "\n";
        fwrite($balances_file, $line);
    }
    fclose($balances_file);
?>