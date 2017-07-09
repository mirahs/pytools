<?php

// autoload_classmap.php @generated by Composer

$vendorDir = dirname(dirname(__FILE__));
$baseDir = dirname($vendorDir);

return array(
    'network\\Packet' => $baseDir . '/network/Packet.php',
    'network\\PacketUtil' => $baseDir . '/network/PacketUtil.php',
    'protocol\\AckChatSendOk' => $baseDir . '/protocol/AckChatSendOk.php',
    'protocol\\AckRoleLoginOk' => $baseDir . '/protocol/AckRoleLoginOk.php',
    'protocol\\AckRoleLoginOkNoRole' => $baseDir . '/protocol/AckRoleLoginOkNoRole.php',
    'protocol\\AckRoleRandNameOk' => $baseDir . '/protocol/AckRoleRandNameOk.php',
    'protocol\\AckSceneEnter' => $baseDir . '/protocol/AckSceneEnter.php',
    'protocol\\AckSceneExit' => $baseDir . '/protocol/AckSceneExit.php',
    'protocol\\AckSceneMove' => $baseDir . '/protocol/AckSceneMove.php',
    'protocol\\AckScenePlayers' => $baseDir . '/protocol/AckScenePlayers.php',
    'protocol\\AckTestPhpOk' => $baseDir . '/protocol/AckTestPhpOk.php',
    'protocol\\AckTestSendOk' => $baseDir . '/protocol/AckTestSendOk.php',
    'protocol\\AckTestXX' => $baseDir . '/protocol/AckTestXX.php',
    'protocol\\Msg' => $baseDir . '/protocol/Msg.php',
    'protocol\\MsgFriendBaseAdd' => $baseDir . '/protocol/MsgFriendBaseAdd.php',
    'protocol\\MsgRoleBase' => $baseDir . '/protocol/MsgRoleBase.php',
    'protocol\\MsgScenePlayer' => $baseDir . '/protocol/MsgScenePlayer.php',
    'protocol\\MsgSceneRotPos' => $baseDir . '/protocol/MsgSceneRotPos.php',
    'protocol\\MsgSceneVector3' => $baseDir . '/protocol/MsgSceneVector3.php',
    'protocol\\MsgTestPhp' => $baseDir . '/protocol/MsgTestPhp.php',
    'protocol\\MsgTestSend' => $baseDir . '/protocol/MsgTestSend.php',
    'protocol\\MsgTestXX' => $baseDir . '/protocol/MsgTestXX.php',
    'protocol\\ReqChatGm' => $baseDir . '/protocol/ReqChatGm.php',
    'protocol\\ReqChatSend' => $baseDir . '/protocol/ReqChatSend.php',
    'protocol\\ReqRoleCreate' => $baseDir . '/protocol/ReqRoleCreate.php',
    'protocol\\ReqRoleLogin' => $baseDir . '/protocol/ReqRoleLogin.php',
    'protocol\\ReqRoleRandName' => $baseDir . '/protocol/ReqRoleRandName.php',
    'protocol\\ReqSceneEnter' => $baseDir . '/protocol/ReqSceneEnter.php',
    'protocol\\ReqSceneEnterFly' => $baseDir . '/protocol/ReqSceneEnterFly.php',
    'protocol\\ReqSceneMove' => $baseDir . '/protocol/ReqSceneMove.php',
    'protocol\\ReqSceneReqPlayers' => $baseDir . '/protocol/ReqSceneReqPlayers.php',
    'protocol\\ReqTestPhp' => $baseDir . '/protocol/ReqTestPhp.php',
    'protocol\\ReqTestSend' => $baseDir . '/protocol/ReqTestSend.php',
    'protocol\\ReqTestXX' => $baseDir . '/protocol/ReqTestXX.php',
);