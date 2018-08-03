//
//  ViewController.swift
//  HelthKit
//
//  Created by Reiya Matsuki on 2018/08/02.
//  Copyright © 2018年 Reiya Matsuki. All rights reserved.
//

import UIKit
import HealthKit
class ViewController: UIViewController {
    
    private let healthStore = HKHealthStore()
    // ワークアウトと心拍数を読み出しに設定
    private let readDataTypes: Set<HKObjectType> = [
        HKWorkoutType.workoutType(),
        HKObjectType.quantityType(forIdentifier: .heartRate)!,
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let types = Set([
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
            ])
        let healthStore = HKHealthStore()
        healthStore.requestAuthorization(toShare: types, read: types, completion: { success, error in
            print(success)
            
            print(error)
        })
        healthStore.requestAuthorization(toShare: nil, read: readDataTypes) { (success, error) in
            guard success, error == nil else {
                return
            }
        
            // do something...
        }
        let allTypes = Set([HKObjectType.quantityType(forIdentifier: .stepCount)!,
                            HKObjectType.workoutType(),
                            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                            HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            HKObjectType.quantityType(forIdentifier: .heartRate)!])
        
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            if !success {
                // Handle the error here.
            }
        }
        
    }
    
    @IBAction func pushButton(){
        // HKSampleから歩数の取得をリクエスト
        let type = HKSampleType.quantityType(forIdentifier: .stepCount)
        let date = Date()
        // 対象日の24時間分の歩数を取得する
        let predicate = HKQuery.predicateForSamples(withStart: date, end: NSDate(timeIntervalSince1970: date.timeIntervalSince1970 + 86400) as Date, options: [])
        
        // 指定期間内のデータを取得する
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var steps: Int = 0
            
            // 指定期間で取得できた歩数の合計を計算
            if (results?.count)! > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps += Int(result.quantity.doubleValue(for: HKUnit.count()))
                }
            }
            print("歩数")
            print(steps)
            // 合計歩数をコールバック関数へ返す
//            completion(steps: steps, error: error)
        }
        
        healthStore.execute(query)
    }
    
    
    
    
    
    
}

