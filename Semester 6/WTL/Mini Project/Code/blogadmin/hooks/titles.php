<?php
	// For help on using hooks, please refer to https://bigprof.com/appgini/help/working-with-generated-web-database-application/hooks

	function titles_init(&$options, $memberInfo, &$args){

		return TRUE;
	}

	function titles_header($contentType, $memberInfo, &$args){
		$header='';

		switch($contentType){
			case 'tableview':
				$header='';
				break;

			case 'detailview':
				$header='';
				break;

			case 'tableview+detailview':
				$header='';
				break;

			case 'print-tableview':
				$header='';
				break;

			case 'print-detailview':
				$header='';
				break;

			case 'filters':
				$header='';
				break;
		}

		return $header;
	}

	function titles_footer($contentType, $memberInfo, &$args){
		$footer='';

		switch($contentType){
			case 'tableview':
				$footer='';
				break;

			case 'detailview':
				$footer='';
				break;

			case 'tableview+detailview':
				$footer='';
				break;

			case 'print-tableview':
				$footer='';
				break;

			case 'print-detailview':
				$footer='';
				break;

			case 'filters':
				$footer='';
				break;
		}

		return $footer;
	}

	function titles_before_insert(&$data, $memberInfo, &$args){
//prevent members from inserting more than one record in table
		$memberid1=($memberInfo['username']);
		$getrecordcount=sqlValue("SELECT COUNT(*) FROM membership_userrecords WHERE tableName='titles' AND memberID='$memberid1'");
		if ($getrecordcount>0) return FALSE;
		return TRUE;
	}

	function titles_after_insert($data, $memberInfo, &$args){

		return TRUE;
	}

	function titles_before_update(&$data, $memberInfo, &$args){

		return TRUE;
	}

	function titles_after_update($data, $memberInfo, &$args){

		return TRUE;
	}

	function titles_before_delete($selectedID, &$skipChecks, $memberInfo, &$args){

		return TRUE;
	}

	function titles_after_delete($selectedID, $memberInfo, &$args){

	}

	function titles_dv($selectedID, $memberInfo, &$html, &$args){

	}

	function titles_csv($query, $memberInfo, &$args){

		return $query;
	}
	function titles_batch_actions(&$args){

		return array();
	}
