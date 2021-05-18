
import UIKit
import BFKit
import GRDB.Swift

extension ZSQLiteKit {
    /// 获取数据对象
    /// filter 搜索条件 例如: id > ? && name = ?
    /// values 对应条件里面的?
    public static func getModel<T: Record>(model: inout T?, filter: String, values: [Any]) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                if let arguments = StatementArguments.init(values) {
                    model = try T.filter(sql: filter, arguments: arguments).fetchOne(db)
                } else {
                    model = try T.filter(sql: filter).fetchOne(db)
                }
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取数据对象
    /// column 字段名称
    public static func getMaxModel<T: Record>(model: inout T?, column: String) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                if try db.tableExists(T.databaseTableName) {
                    model = try T.select(max(Column.init(column))).fetchOne(db)
                }
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取指定条件纪录数
    /// filter 搜索条件 例如: id > ? && name = ?
    /// values 对应条件里面的?
    public static func getArrayCount<T: Record>(model: inout T?, count: inout Int, filter: String, values: [Any])  {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                if let arguments = StatementArguments.init(values) {
                    count = try T.filter(sql: filter, arguments: arguments).fetchCount(db)
                } else {
                    count = try T.filter(sql: filter).fetchCount(db)
                }
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取制定条件对象集合
    /// filter 搜索条件 例如: id > ? && name = ?
    /// values 对应条件里面的?
    public static func getArrayWhere<T: Record>(models: inout [T]?, filter: String, values: [Any], order: String? = nil, page: Int = 0) {
        do {
            let count = kPageCount
            try ZSQLiteKit.shared.connection?.write({ db in
                if let arguments = StatementArguments.init(values) {
                    if let strOrder = order {
                        models = try T.filter(sql: filter, arguments: arguments).order(Column(strOrder).desc).limit(page, offset: page * count).fetchAll(db)
                    } else {
                        models = try T.filter(sql: filter, arguments: arguments).limit(page, offset: page * count).fetchAll(db)
                    }
                } else {
                    if let strOrder = order {
                        models = try T.filter(sql: filter).limit(page, offset: page * count).order(Column(strOrder).desc).fetchAll(db)
                    } else {
                        models = try T.filter(sql: filter).limit(page, offset: page * count).fetchAll(db)
                    }
                }
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取所有对象
    public static func getArrayAll<T: Record>(models: inout [T]?) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                models = try T.fetchAll(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 设置对象
    public static func setModel<T: Record>(model: T) {
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                try model.save(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 设置对象集合
    public static func setModels<T: Record>(models: [T]) {
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                for model in models {
                    try model.save(db)
                }
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 添加对象
    public static func insModel<T: Record>(model: T) {
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                try model.insert(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 修改对象
    public static func updModel<T: Record>(model: T) {
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                try model.update(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 删除对象
    @discardableResult
    public static func delModel<T: Record>(model: T) -> Bool {
        var success: Bool = false
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                success = try model.delete(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
        return success
    }
    /// 删除某表数据
    @discardableResult
    public static func delModelAll<T: Record>(_ : T) -> Int {
        var count: Int = 0
        do {
            try ZSQLiteKit.shared.connection?.write({ (db) in
                count = try T.deleteAll(db)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
        return count
    }
    /// 获取用户行为集合
    public static func getArrayBehavior<T: ZModelUserBehavior>(models: inout [T]?, type: ZEnumUserBehaviorType, page: Int = 0, count: Int = kPageCount) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                models = try T.fetchAll(db,
                                        sql: "SELECT t1.*,t2.* FROM tb_user_behavior t1 LEFT JOIN tb_user t2 ON t1.behavior_userid = t2.userid WHERE t1.login_userid = ? AND t1.behavior_type = ?  ORDER BY t1.behavior_time DESC LIMIT ? OFFSET ?",
                                        arguments: [ZSettingKit.shared.userId, type, count, page * count])
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
}

extension ZSQLiteKit {
    
    /// 获取未读数量
    public static func getMessageUnreadCount(count: inout Int) {
        do {
            let loginuserid = ZSettingKit.shared.userId
            try ZSQLiteKit.shared.connection?.write({ db in
                let row = try Row.fetchOne(db, sql: "SELECT COUNT(t1.message_id) as unReadCount FROM tb_message t1 WHERE t1.login_userid = ? AND t1.message_read_state = 0 ", arguments: [loginuserid])
                count = Int(row?["unReadCount"] as? Int64 ?? 0)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取聊天记录列表
    public static func getArrayMessageRecord<T: ZModelMessageRecord>(models: inout [T]?, page: Int) {
        do {
            let loginuserid = ZSettingKit.shared.userId
            let sql = "SELECT t1.*,t2.*,t3.*, (SELECT COUNT(*) FROM tb_message t3 WHERE t3.message_userid = t1.userid AND t3.message_read_state = 0) AS message_unread_count FROM tb_message_record t1 LEFT JOIN tb_message t2 ON t1.message_id = t2.message_id LEFT JOIN tb_user t3 ON t1.message_userid = t3.userid WHERE t1.login_userid = ? GROUP BY t1.message_userid ORDER BY t3.role DESC, t1.message_time DESC LIMIT \(kPageCount) OFFSET \((page - 1) * kPageCount)"
            try ZSQLiteKit.shared.connection?.write({ db in
                models = try T.fetchAll(db, sql: sql, arguments: [loginuserid])
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 获取指定某人的消息对话列表
    public static func getArrayMessage<T: ZModelMessage>(models: inout [T]?, userid: String, time: Double = Date().timeIntervalSince1970) {
        do {
            let loginuserid = ZSettingKit.shared.userId
            try ZSQLiteKit.shared.connection?.write({ db in
                models = try T.fetchAll(db, sql: "SELECT t1.* FROM tb_message t1 WHERE t1.message_userid = ? AND t1.login_userid = ? AND t1.message_time < ? ORDER BY t1.message_time DESC LIMIT ? OFFSET 0", arguments: [userid, loginuserid, time, kPageCount])
            })
            ZSQLiteKit.setMessageUnRead(userid: userid)
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 修改某个人的消息为已读
    public static func setMessageUnRead(userid: String) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                try db.execute(sql: "UPDATE tb_message SET message_read_state = 1 WHERE message_userid = ?", arguments: [userid])
            })
            NotificationCenter.default.post(name: Notification.Names.MessageUnReadCount, object: nil)
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 修改某条消息为已读
    public static func setMessageUnRead(messageid: String) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                try db.execute(sql: "UPDATE tb_message SET message_read_state = 1 WHERE message_id = ?", arguments: [messageid])
            })
            NotificationCenter.default.post(name: Notification.Names.MessageUnReadCount, object: nil)
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 修改呼叫数量 +1
    public static func setMessageCallCount(messageids: [String]) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                var sql = "UPDATE tb_message SET message_call_count = message_call_count + 1 WHERE message_id IN ("
                for id in messageids {
                    sql += "'\(id)',"
                }
                sql.removeLast()
                sql += ");"
                try db.execute(sql: sql)
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
    /// 删除指定某人的消息对话
    public static func delMessageRecord(userid: String) {
        do {
            try ZSQLiteKit.shared.connection?.write({ db in
                try db.execute(sql: "DELETE tb_message_record WHERE message_userid = ? AND login_userid = ?", arguments: [userid, ZSettingKit.shared.userId])
                try db.execute(sql: "DELETE tb_message WHERE message_userid = ? AND login_userid = ?", arguments: [userid, ZSettingKit.shared.userId])
            })
        } catch {
            BFLog.error("sqlite write error: \(error.localizedDescription)")
        }
    }
}
