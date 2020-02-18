<?php
    extract($_POST);

    $transactions_path = "transactions.txt";
    $balances_path = "balances.txt";


    //Read the previous lines of the file
    $total_lines = 0;
    $transactions_file = fopen($transactions_path, "r");
    while(!feof($transactions_file)){
        fgets($transactions_file);
        $total_lines++;
    }
    fclose($transactions_file);

    //append a new line
    $transactions_file = fopen($transactions_path, "a") or die("Unable to open file!");
    $new =  $total_lines . "," . $id . "," . $name . "," . $last_name . "," . $type . "," . $date . "," . $total . "\n";
    fwrite($transactions_file, $new);
    fclose($transactions_file);


    $balances_lines = array();
    $balances_file = fopen($balances_path, "r");
    $found = false;
    while(!feof($balances_file)) {
        $line = fgets($balances_file);
        $arr = explode(",", $line);
        if ($arr[0] == $id){
            $found = true;
            $balance = floatval($arr[4]);
            if($type == 'credito'){
                $balance+= floatval($total);
            } else if($type == 'debito'){
                $balance-= floatval($total);
            }
            $balances_lines[] = $id . "," . $name . "," . $last_name . "," . $date . "," . $balance . "\n";
        } else {
            $balances_lines[] = $line;
        }
    }

    if(!$found){
        $balances_lines[] = $id . "," . $name . "," . $last_name . "," . $date . "," . $total . "\n";
    }
    fclose($balances_file);


    $balances_file = fopen($balances_path, "w") or die("Unable to open file!");;
    for ($i=0; $i < count($balances_lines) ; $i++) { 
        fwrite($balances_file, $balances_lines[$i]);
    }
    fclose($balances_file);



?>
