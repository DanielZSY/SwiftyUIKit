import UIKit
import HandyJSON
import GRDB.Swift

public class ZModelMessageRecord: ZModelBase {
    
    public class override var databaseTableName: String { "tb_message_record" }
    public enum Columns: String, ColumnExpression {
        case message_userid, message_id, message_unread_count, login_userid
    }
    public var message_user: ZModelUserBase?
    public var message_user_local: ZModelUserLocal?
    public var message_userid: String = ""
    public var message_id: String = ""
    public var message_unread_count: Int64 = 0
    public var login_userid: String = ZSettingKit.shared.userId
    
    public required init() {
        super.init()
    }
    public required init<T: ZModelBase>(instance: T) {
        super.init(instance: instance)
        guard let model = instance as? ZModelMessageRecord else {
            return
        }
        if let user = model.message_user {
            self.message_user = ZModelUserBase.init(instance: user)
        }
        if let user = model.message_user_local {
            self.message_user_local = ZModelUserLocal.init(instance: user)
        }
        self.message_id = model.message_id
        self.message_userid = model.message_userid
        self.message_unread_count = model.message_unread_count
        self.login_userid = model.login_userid
    }
    public required init(row: Row) {
        super.init(row: row)
        self.message_user = ZModelUserBase.init(row: row)
        self.message_user_local = ZModelUserLocal.init(row: row)
        
        self.message_id = row[Columns.message_id] ?? ""
        self.message_userid = row[Columns.message_userid] ?? ""
        self.message_unread_count = row[Columns.message_unread_count] ?? 0
        self.login_userid = row[Columns.login_userid] ?? ""
    }
    public override func encode(to container: inout PersistenceContainer) {
        super.encode(to: &container)
        
        container[Columns.message_userid] = self.message_userid
        container[Columns.message_id] = self.message_id
        container[Columns.login_userid] = self.login_userid
    }
    public override func mapping(mapper: HelpingMapper) {
        super.mapping(mapper: mapper)
        
    }
}
