#!/usr/bin/env python
# coding:utf-8
import conf
from util import util, util_proto

# 类型映射
lan_types = {
    'u8': ('byte', 'number'),
    'i8': ('sbyte', 'number'),
    'u16': ('ushort', 'number'),
    'i16': ('short', 'number'),
    'u32': ('uint', 'number'),
    'i32': ('int', 'number'),
    'u64': ('ulong', 'Long'),
    'i64': ('long', 'Long'),
    'f32': ('float', 'number'),
    'f64': ('double', 'number'),
    'string': ('string', 'string'),
}


# 解析入口
def parse(code_path, common_path, protos, _tmp_protos_file):
    name_ids = list()
    for proto in protos:
        name_id = dict()
        name_id['mess_name'] = proto['mess_name']
        name_id['mess_id']  = proto['mess_id']
        name_id['mess_note'] = proto['mess_note']
        name_ids.append(name_id)

        ProtoTypeScript(code_path, proto).parse()

    protocol_const(code_path, name_ids)


# 协议常量
def protocol_const(code_path, mess_name_ids):
    file_name = code_path + 'Msg.ts'

    _str_msg_head = 'export const enum Msg {\n'
    _str_msg_end = '}\n'
    _str_msg = ''

    for mess_name_id in mess_name_ids:
        mess_name = mess_name_id['mess_name']
        mess_id = mess_name_id['mess_id']
        mess_note = mess_name_id['mess_note']

        _str_msg += '\t/**' + mess_note + '*/\n\t' + (util_proto.proto_name_msg2(mess_name)).ljust(30, chr(32)) + '= ' + str(mess_id) + ',\n'

    _str_msg = _str_msg_head + _str_msg + _str_msg_end
    with open(file_name, 'w+') as fd:
        fd.write(_str_msg)


# 类型转换
def trans_mess_type(proto):
    for idx in xrange(len(proto['mess_fields'])):
        mess_field = proto['mess_fields'][idx]

        mess_field['field_type_ori'] = mess_field['field_type']
        if mess_field['field_type'] in lan_types:
            mess_field['field_type'] = lan_types[mess_field['field_type']]

        proto['mess_fields'][idx] = mess_field

    return proto


class ProtoTypeScript(object):
    def __init__(self, code_path, proto):
        self._code_path = code_path
        self._proto = trans_mess_type(proto)

        self._mess_name = self._proto['mess_name']

        self._set_class_name()
        self._set_packet_id()

        self._set_head()
        self._set_end()

        self._set_priv_var()
        self._set_encode()
        self._set_get_buffer()
        self._set_decode()
        self._set_set_get()

    def parse(self):
        file_name = self._code_path + self._str_class_name + '.ts'
        content = self._str_head + '\n\n' + self._str_priv_var + '\n' + self._str_decode + '\n' + self._str_encode + '\n' + self._str_get_buffer + '\n' + self._str_set_get[:-1] + self._str_end
        with open(file_name, 'w+') as fd:
            fd.write(content)

    def _set_class_name(self):
        self._str_class_name = self._mess_name

    def _set_packet_id(self):
        self._packet_id = self._proto['mess_id']

    def _set_head(self):
        self._str_head = conf.typescript_cc_import_packages + ';\n'

        msg_types = []
        for mess_field in self._proto['mess_fields']:
            field_type = mess_field['field_type']
            if isinstance(field_type, basestring) and field_type not in msg_types:
                msg_types.append(field_type)

        for msg_type in msg_types:
            self._str_head += 'import ' + msg_type + ' from \'./' + msg_type + '\';\n'

    def _set_end(self):
        self._str_end = '\n}\n'

    def _set_priv_var(self):
        self._str_priv_var = 'export default class ' + self._str_class_name + ' {\n'
        for mess_field in self._proto['mess_fields']:
            field_op = mess_field['field_op']
            field_type = mess_field['field_type']
            if not isinstance(field_type, basestring):
                field_type = field_type[1]
            field_name = mess_field['field_name']
            field_name_flag = field_name + '_flag'
            field_name_m = '_' + field_name
            if field_op == 'repeated':
                self._str_priv_var += '\tprivate ' + field_name_m + ': ' + field_type + '[] = [];\n'
            elif field_op == 'optional':
                self._str_priv_var += '\tprivate ' + field_name_flag + ': number = 0;\n'
                self._str_priv_var += '\tprivate ' + field_name_m + ': ' + field_type + ';\n'
            else:
                self._str_priv_var += '\tprivate ' + field_name_m + ': ' + field_type + ';\n'

    def _set_encode(self):
        self._str_encode = '\tpublic Encode(): Packet {\n\t\tlet packet: Packet = new Packet();\n'
        for mess_field in self._proto['mess_fields']:
            field_op = mess_field['field_op']
            field_type_ori = mess_field['field_type_ori']
            field_type = mess_field['field_type']
            if not isinstance(field_type, basestring):
                field_type_fun = field_type[0].capitalize()
                field_type = field_type[1]
            field_name = mess_field['field_name']
            field_name_flag = field_name + '_flag'
            field_name_m = 'this._' + field_name
            field_name_count = field_name + '_count'
            if field_op == 'repeated':
                self._str_encode += '\t\tlet ' + field_name_count + ': number = ' + field_name_m + '.length;\n'
                self._str_encode += '\t\tpacket.WriteUshort(' + field_name_count + ');\n'
                self._str_encode += '\t\tfor (let i: number = 0; i < ' + field_name_count + '; i++) {\n'
                self._str_encode += '\t\t\tlet xxx: ' + field_type + ' = ' + field_name_m + '[i];\n'
                if not lan_types.get(field_type_ori):
                    self._str_encode += '\t\t\tpacket.WriteBuffer(xxx' + '.GetBuffer());\n\t\t}\n'
                else:
                    self._str_encode += '\t\t\tpacket.Write' + field_type_fun + '(xxx);\n\t\t}\n'
            elif field_op == 'optional':
                self._str_encode += '\t\tpacket.WriteByte(this.' + field_name_flag + ');\n'
                self._str_encode += '\t\tif (this.' + field_name_flag + ' == 1) {\n'
                if not lan_types.get(field_type_ori):
                    self._str_encode += '\t\t\tpacket.WriteBuffer(' + field_name_m + '.GetBuffer());\n\t\t}\n'
                else:
                    self._str_encode += '\t\t\tpacket.Write' + field_type_fun + '(' + field_name_m + ');\n\t\t}\n'
            else:
                if not lan_types.get(field_type_ori):
                    self._str_encode += '\t\tpacket.WriteBuffer(' + field_name_m + '.GetBuffer());\n'
                else:
                    self._str_encode += '\t\tpacket.Write' + field_type_fun + '(' + field_name_m + ');\n'
        if not self._str_class_name.startswith('Msg'):
            self._str_encode += '\t\tpacket.Encode(' + self._packet_id + ');\n'
        self._str_encode += '\t\treturn packet;\n\t}\n'

    def _set_decode(self):
        self._str_decode = '\tconstructor(packet?: Packet) {\n'
        self._str_decode += '\t\tif (packet) {\n'
        for mess_field in self._proto['mess_fields']:
            field_op = mess_field['field_op']
            field_type_ori = mess_field['field_type_ori']
            field_type = mess_field['field_type']
            if not isinstance(field_type, basestring):
                field_type_fun = field_type[0].capitalize()
                field_type = field_type[1]
            field_name = mess_field['field_name']
            field_name_m = 'this._' + field_name
            field_name_flag = field_name + '_flag'
            field_name_count = field_name + '_count'
            if field_op == 'repeated':
                self._str_decode += '\t\t\t' + field_name_m + ' = [];\n'
                self._str_decode += '\t\t\tlet ' + field_name_count + ': number = packet.ReadUshort();\n'
                self._str_decode += '\t\t\tfor (let i: number = 0; i < ' + field_name_count + '; i++) {\n'
                if not lan_types.get(field_type_ori):
                    self._str_decode += '\t\t\t\t' + field_name_m + '.push(new ' + field_type + '(packet));\n\t\t\t}\n'
                else:
                    self._str_decode += '\t\t\t\t' + field_name_m + '.push(packet.Read' + field_type_fun + '());\n\t\t\t}\n'
            elif field_op == 'optional':
                self._str_decode += '\t\t\tthis.' + field_name_flag + ' = packet.ReadByte();\n'
                self._str_decode += '\t\t\tif (this.' + field_name_flag + ' == 1) {\n'
                if not lan_types.get(field_type_ori):
                    self._str_decode += '\t\t\t\t' + field_name_m + ' = new ' + field_type + '(packet);\n'
                else:
                    self._str_decode += '\t\t\t\t' + field_name_m + ' = ' + 'packet.Read' + field_type_fun + '();\n'
                self._str_decode += '\t\t\t}\n'
            else:
                if not lan_types.get(field_type_ori):
                    self._str_decode += '\t\t\t' + field_name_m + ' = new ' + field_type + '(packet);\n'
                else:
                    self._str_decode += '\t\t\t' + field_name_m + ' = packet.Read' + field_type_fun + '();\n'
        self._str_decode += '\t\t}\n'
        self._str_decode += '\t}\n'

    def _set_set_get(self):
        self._str_set_get = ''
        for mess_field in self._proto['mess_fields']:
            field_op = mess_field['field_op']
            field_type = mess_field['field_type']
            if not isinstance(field_type, basestring):
                field_type = field_type[1]
            field_name = mess_field['field_name']
            field_name_flag = field_name + '_flag'
            field_name_m = 'this._' + field_name
            if field_op == 'repeated':
                self._str_set_get += '\tpublic get ' + field_name + '(): ' + field_type + '[] {return ' + field_name_m + '; }\n'
                self._str_set_get += '\tpublic set ' + field_name + '(value: ' + field_type + '[])' + ' { ' + field_name_m + ' = value; }\n'
            elif field_op == 'optional':
                self._str_set_get += '\tpublic get ' + field_name + '(): ' + field_type + ' { return ' + field_name_m + '; }\n'
                self._str_set_get += '\tpublic set ' + field_name + '(value: ' + field_type + ')' + ' { this.' + field_name_flag + ' = 1; ' + field_name_m + ' = value; }\n'
            else:
                self._str_set_get += '\tpublic get ' + field_name + '(): ' + field_type + ' { return ' + field_name_m + '; }\n'
                self._str_set_get += '\tpublic set ' + field_name + '(value: ' + field_type + ')' + ' { ' + field_name_m + ' = value; }\n'

    def _set_get_buffer(self):
        self._str_get_buffer = '\tpublic GetBuffer(): ByteBuffer {\n\t\treturn this.Encode().GetBuffer();\n\t}\n'
