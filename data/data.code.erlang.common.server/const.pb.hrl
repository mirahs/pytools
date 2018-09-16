-define(c_chat_send,                    1510). % 发送聊天信息
-define(s_chat_send_ok,                 1520). % 聊天信息返回
-define(c_chat_gm,                      1530). % GM命令
-define(c_role_login,                   1010). % 角色登录
-define(c_role_create,                  1020). % 角色创建
-define(c_role_rand_name,               1030). % 请求随机名字
-define(s_role_rand_name_ok,            1040). % 随机名字返回
-define(s_role_login_ok,                1050). % 登录成功
-define(s_role_login_ok_no_role,        1060). % 登录成功(无角色)
-define(c_scene_enter_fly,              2010). % 请求进入场景(飞)
-define(c_scene_enter,                  2020). % 请求进入场景
-define(c_scene_move,                   2030). % 行走数据
-define(s_scene_enter,                  2040). % 进入场景成功
-define(s_scene_players,                2050). % 场景玩家列表
-define(s_scene_exit,                   2060). % 退出场景成功
-define(c_scene_req_players,            2070). % 请求玩家列表
-define(s_scene_move,                   2080). % 行走数据
-define(c_test_send,                    40010).% 测试发送
-define(s_test_send_ok,                 40020).% 测试返回
-define(c_test_x_x,                     40040).% 
-define(s_test_x_x,                     40050).% 
-define(c_test_php,                     40060).% 
-define(s_test_php_ok,                  40070).% 
-define(c_test_js,                      40080).% 
-define(s_test_js_ok,                   40090).% 
