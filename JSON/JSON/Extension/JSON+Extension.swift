//
//  JSON+Extension.swift
//  JSON
//
//  Created by 박세라 on 2022/03/10.
//

import Foundation
import SwiftyJSON

extension JSON {
    
    func decode<T: Decodable>(type: T.Type) -> T? {
        let data: Data
        
        do {
            data = try rawData()
        } catch {
            print("JSON decoding 실패: \(T.self)\n\t\(error.localizedDescription)")
            
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch let error as DecodingError {
            switch error {
            case .keyNotFound(let key, _):
                print("JSON decoding 실패: \(T.self), error: \(error.localizedDescription) key -> \(key)가 없습니다.")
            case .valueNotFound(let type, let context):
                context.codingPath.forEach {
                    if $0.intValue == nil {
                        print("JSON decoding 실패: \(T.self), error: \(error.localizedDescription) key -> \($0.stringValue)(\(type))가 없습니다.")
                    }
                }
            default:
                print("JSON decoding 실패: \(T.self), error: \(error.localizedDescription)")
            }
            
            return nil
        } catch {
            print("JSON decoding 실패: \(T.self), error: \(error.localizedDescription)")
            
            return nil
        }
    }
}
