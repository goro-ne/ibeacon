//
//  ViewController.swift
//  ibeacon-test
//
//  Created by Goro Hayakawa on 2015/04/21.
//  Copyright (c) 2015年 Goro Hayakawa. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var status : UILabel = UILabel()
    var version : UILabel = UILabel()
    var uuid : UILabel = UILabel()
    var major : UILabel = UILabel()
    var minor : UILabel = UILabel()
    var accuracy : UILabel = UILabel()
    var rssi : UILabel = UILabel()
    var distance : UILabel = UILabel()
    
    //UUIDカラNSUUIDを作成
    //let proximityUUID = NSUUID(UUIDString:"AAAAAAAA-AAAA-AAAA-AAAA-AAAAAAAAAAAA")
    let proximityUUID = NSUUID(UUIDString:"1F852D13-C909-49B4-989B-9AC2D4233C9A")
    var region  = CLBeaconRegion()
    var manager = CLLocationManager()
    
    
    func initView () {
        //ビューの初期化
        var height:Int = 60
        self.status.frame = CGRectMake(0,0,300,18)
        self.status.layer.position = CGPoint(x: self.view.bounds.width/2, y: CGFloat(height))
        self.status.backgroundColor = UIColor.orangeColor()
        self.status.text = "status"
        self.status.font = UIFont.systemFontOfSize(10)
        self.status.textColor = UIColor.whiteColor()
        self.status.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.status)
        
        height += 20
        self.version.frame = CGRectMake(0,0,300,18)
        self.version.layer.position = CGPoint(x: self.view.bounds.width/2, y: CGFloat(height))
        self.version.backgroundColor = UIColor.orangeColor()
        self.version.text = "version"
        self.version.font = UIFont.systemFontOfSize(10)
        self.version.textColor = UIColor.whiteColor()
        self.version.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.version)
        
        height += 20
        self.uuid.frame = CGRectMake(0,0,300,18)
        self.uuid.layer.position = CGPoint(x: self.view.bounds.width/2, y: CGFloat(height))
        self.uuid.backgroundColor = UIColor.orangeColor()
        self.uuid.text = "uuid"
        self.uuid.font = UIFont.systemFontOfSize(10)
        self.uuid.textColor = UIColor.whiteColor()
        self.uuid.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.uuid)
        
        height += 20
        self.major.frame = CGRectMake(0,0,300,18)
        self.major.layer.position = CGPoint(x: self.view.bounds.width/2, y: CGFloat(height))
        self.major.backgroundColor = UIColor.orangeColor()
        self.major.text = "major"
        self.major.font = UIFont.systemFontOfSize(10)
        self.major.textColor = UIColor.whiteColor()
        self.major.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.major)
        
        height += 20
        self.minor.frame = CGRectMake(0,0,300,18)
        self.minor.layer.position = CGPoint(x: self.view.bounds.width/2, y: CGFloat(height))
        self.minor.backgroundColor = UIColor.orangeColor()
        self.minor.text = "minor"
        self.minor.font = UIFont.systemFontOfSize(10)
        self.minor.textColor = UIColor.whiteColor()
        self.minor.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.minor)
        
        height += 20
        self.accuracy.frame = CGRectMake(0,0,300,18)
        self.accuracy.layer.position = CGPoint(x: self.view.bounds.width/2, y: CGFloat(height))
        self.accuracy.backgroundColor = UIColor.orangeColor()
        self.accuracy.text = "accuracy"
        self.accuracy.font = UIFont.systemFontOfSize(10)
        self.accuracy.textColor = UIColor.whiteColor()
        self.accuracy.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.accuracy)
        
        height += 20
        self.rssi.frame = CGRectMake(0,0,300,18)
        self.rssi.layer.position = CGPoint(x: self.view.bounds.width/2, y: CGFloat(height))
        self.rssi.backgroundColor = UIColor.orangeColor()
        self.rssi.text = "rssi"
        self.rssi.font = UIFont.systemFontOfSize(10)
        self.rssi.textColor = UIColor.whiteColor()
        self.rssi.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.rssi)
        
        height += 20
        self.distance.frame = CGRectMake(0,0,300,18)
        self.distance.layer.position = CGPoint(x: self.view.bounds.width/2, y: CGFloat(height))
        self.distance.backgroundColor = UIColor.orangeColor()
        self.distance.text = "distance"
        self.distance.font = UIFont.systemFontOfSize(10)
        self.distance.textColor = UIColor.whiteColor()
        self.distance.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.distance)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        initView()

        
        
        //CLBeaconRegionを作成
        region = CLBeaconRegion(proximityUUID: proximityUUID, identifier: "EstimotionRegion")
        
        //デリゲートの設定
        manager.delegate = self
        
        
        /*
        位置情報サービスへの認証状態を取得する
        NotDetermined   --  アプリ起動後、位置情報サービスへのアクセスを許可するかまだ選択されていない状態
        Restricted      --  設定 > 一般 > 機能制限により位置情報サービスの利用が制限中
        Denied          --  ユーザーがこのアプリでの位置情報サービスへのアクセスを許可していない
        Authorized      --  位置情報サービスへのアクセスを許可している
        */

        
        switch CLLocationManager.authorizationStatus() {
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            //iBeaconによる領域観測を開始する
            println("観測開始")
            self.status.text = "status: Starting Monitor"
            self.manager.startRangingBeaconsInRegion(self.region)
            break

        case .NotDetermined:
            println("認可承認")
            self.status.text = "status: Accept"

            //デバイスに許可に促す
            let str = UIDevice.currentDevice().systemVersion
            let majorVersion: Int? = String(str[str.startIndex]).toInt()

            if (nil != majorVersion) {
                self.version.text = "version: \(majorVersion!)"

                if (majorVersion! >= 8){
                    //iOS8以降は許可をリクエストする関数をCallする
                    self.status.text = "status: Authorization"
                    self.manager.requestAlwaysAuthorization()
                } else {
                    self.status.text = "status: StartRangingBeacon"
                    self.manager.startRangingBeaconsInRegion(self.region)
                }
            }
            break
            
        case .Restricted, .Denied:
            //デバイスから拒否状態
            println("Restricted")
            self.status.text = "status: Restructed"
            break
            
        default:
            break
        }
    
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //以下 CCLocationManagerデリゲートの実装---------------------------------------------->
    
    /*
    - (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
    Parameters
    manager : The location manager object reporting the event.
    region  : The region that is being monitored.
    */
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        manager.requestStateForRegion(region)
        self.status.text = "Scanning..."
        println("Scanning...")
    }
    
    /*
    - (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
    Parameters
    manager :The location manager object reporting the event.
    state   :The state of the specified region. For a list of possible values, see the CLRegionState type.
    region  :The region whose state was determined.
    */
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion inRegion: CLRegion!) {
        if (state == .Inside) {
            //領域内にはいったときに距離測定を開始
            self.status.text = "Inside..."
            println("Inside...")
            manager.startRangingBeaconsInRegion(region)
        }
    }
    
    /*
    リージョン監視失敗（bluetoosの設定を切り替えたりフライトモードを入切すると失敗するので１秒ほどのdelayを入れて、再トライするなど処理を入れること）
    - (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
    Parameters
    manager : The location manager object reporting the event.
    region  : The region for which the error occurred.
    error   : An error object containing the error code that indicates why region monitoring failed.
    */
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("monitoringDidFailForRegion \(error)")
        self.status.text = "Error :("
        println("Error")
    }
    
    /*
    - (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
    Parameters
    manager : The location manager object that was unable to retrieve the location.
    error   : The error object containing the reason the location or heading could not be retrieved.
    */
    //通信失敗
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("didFailWithError \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        self.status.text = "Possible Match"
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        reset()
    }
    
    /*
    beaconsを受信するデリゲートメソッド。複数あった場合はbeaconsに入る
    - (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
    Parameters
    manager : The location manager object reporting the event.
    beacons : An array of CLBeacon objects representing the beacons currently in range. You can use the information in these objects to determine the range of each beacon and its identifying information.
    region  : The region object containing the parameters that were used to locate the beacons
    */
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!){
        println(beacons)
        
        if(beacons.count == 0) { return }
        //複数あった場合は一番先頭のものを処理する
        var beacon = beacons[0] as! CLBeacon
        
        /*
        beaconから取得できるデータ
        proximityUUID   :   regionの識別子
        major           :   識別子１
        minor           :   識別子２
        proximity       :   相対距離
        accuracy        :   精度
        rssi            :   電波強度
        */
        if (beacon.proximity == CLProximity.Unknown) {
            self.distance.text = "Unknown Proximity"
            reset()
            return
        } else if (beacon.proximity == CLProximity.Immediate) {
            self.distance.text = "Immediate"
        } else if (beacon.proximity == CLProximity.Near) {
            self.distance.text = "Near"
        } else if (beacon.proximity == CLProximity.Far) {
            self.distance.text = "Far"
        }
        self.status.text   = "OK"
        self.uuid.text     = beacon.proximityUUID.UUIDString
        self.major.text    = "\(beacon.major)"
        self.minor.text    = "\(beacon.minor)"
        self.accuracy.text = "\(beacon.accuracy)"
        self.rssi.text     = "\(beacon.rssi)"
    }
    
//    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: NSArray!, inRegion region: CLBeaconRegion!) {
//        println(beacons)
//        
//        if(beacons.count == 0) { return }
//        //複数あった場合は一番先頭のものを処理する
//        var beacon = beacons[0] as! CLBeacon
//        
//        /*
//        beaconから取得できるデータ
//        proximityUUID   :   regionの識別子
//        major           :   識別子１
//        minor           :   識別子２
//        proximity       :   相対距離
//        accuracy        :   精度
//        rssi            :   電波強度
//        */
//        if (beacon.proximity == CLProximity.Unknown) {
//            self.distance.text = "Unknown Proximity"
//            reset()
//            return
//        } else if (beacon.proximity == CLProximity.Immediate) {
//            self.distance.text = "Immediate"
//        } else if (beacon.proximity == CLProximity.Near) {
//            self.distance.text = "Near"
//        } else if (beacon.proximity == CLProximity.Far) {
//            self.distance.text = "Far"
//        }
//        self.status.text   = "OK"
//        self.uuid.text     = beacon.proximityUUID.UUIDString
//        self.major.text    = "\(beacon.major)"
//        self.minor.text    = "\(beacon.minor)"
//        self.accuracy.text = "\(beacon.accuracy)"
//        self.rssi.text     = "\(beacon.rssi)"
//    }
    
    func reset(){
        self.status.text   = "none"
        self.uuid.text     = "none"
        self.major.text    = "none"
        self.minor.text    = "none"
        self.accuracy.text = "none"
        self.rssi.text     = "none"
    }
/*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
*/
}

