//
//  DatingPersonLocationView.swift
//  MeetMe
//
//  Created by ViVID on 3/30/17.
//  Copyright © 2017 ViVID. All rights reserved.
//

import UIKit
import MapKit


class DatingPersonLocationView: UIViewController,MKMapViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var gestureIcon: UIImageView!
    var firstX = CGFloat()
    var firstY = CGFloat()
    var pan = UIPanGestureRecognizer()
    var Tab = UITapGestureRecognizer()
    var PersonimageName = NSString()
    @IBOutlet weak var outletGestureButt: UIButton!
    @IBOutlet weak var locatonTable: UITableView!
    @IBOutlet weak var gestureview: UIView!
    @IBOutlet weak var mapview: MKMapView!


    var PersonArr = NSDictionary()
    var TableArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        let  Namearr = NSArray.init(objects: "Jenna White","Marry Bighton","James","Carrie Mathison","Angelica Malroes","Abbey Root","Harry","Miya","Juily","Amelia")
        let Distancearr =  NSArray.init(objects: "400m away","300m away","500m  away","200m away","400m away","300m away","300m away","100m away","200m away","300m away")
        let Agearr =  NSArray.init(objects: "22","28","25","23","22","24","27","21","20","18")
        let Latarray =  NSArray.init(objects: "27.297306","21.384312"," 20.835470","16.390444","15.905263","24.856621","21.121735"," 11.932860","11.981863","20.280544")
        let Lonarray =  NSArray.init(objects: "82.032623","72.958191","81.719482","81.529472","73.821320","87.777565","70.116203","75.571861","75.670265","78.719131")
        
            for i in 0 ..<  Namearr.count
        {
            let dict = NSMutableDictionary()
            dict.setObject(Namearr.objectAtIndex(i), forKey: "name")
            dict.setObject(Distancearr.objectAtIndex(i), forKey: "distance")
            dict.setObject("nearby", forKey: "listname")
            dict.setObject("\(i).jpeg", forKey: "imagename")
            dict.setObject("I'm a little bit crazy,love to dance , eat & and obviously to meet new people! Feel free to send me invitation, we will probably meet one day or another! ;-)", forKey: "about")
            dict.setObject(Agearr.objectAtIndex(i) as! String,forKey: "age")
            dict.setObject(Latarray.objectAtIndex(i) as! String,forKey: "lat")
            dict.setObject(Lonarray.objectAtIndex(i) as! String,forKey: "lon")
            TableArr.addObject(dict)
        }
        PersonArr = TableArr.objectAtIndex(0) as! NSDictionary
        
        
        
        
        self.locatonTable.registerNib(UINib.init(nibName: "DatingPersonCell", bundle: nil), forCellReuseIdentifier: "DatingPersonCell")

        
    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: PersonArr.valueForKey("lat")!.doubleValue, longitude: PersonArr.valueForKey("lon")!.doubleValue)
        let annotation = MKPointAnnotation()
        annotation.title = PersonArr.valueForKey("name") as? String
        annotation.subtitle = PersonArr.valueForKey("distance") as? String
        annotation.coordinate = coordinate
        self.mapview.addAnnotation(annotation)
        PersonimageName = PersonArr.valueForKey("imagename") as! String
        self.pan.delegate = self
        self.pan = UIPanGestureRecognizer(target: self, action: #selector(self.move))
        self.pan.minimumNumberOfTouches = 1
        self.pan.maximumNumberOfTouches = 1
        self.gestureview.addGestureRecognizer(self.pan)
        self.Tab.delegate = self
        self.Tab = UITapGestureRecognizer(target: self, action: #selector(self.HandleTab))
        self.outletGestureButt.addGestureRecognizer(self.Tab)
        self.locatonTable.separatorColor = UIColor.blackColor()

   }
    func mapView(mV: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?
    {
        var pinView : MKAnnotationView? = nil
        pinView = self.mapview.dequeueReusableAnnotationViewWithIdentifier("currentLocation")
        let defaultPinID = "currentLocation"
        if pinView == nil  {
            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: defaultPinID)
        }
        pinView!.canShowCallout = true
        
        let pulsev = UIView.init(frame: CGRectMake(((pinView?.frame.size.width)! - 130)/2,((pinView?.frame.size.height)! - 130)/2, 130, 130))
        pulsev.layer.cornerRadius = pulsev.frame.size.height / 2
        pulsev.layer.masksToBounds = true
        pulsev.backgroundColor = UIColor.clearColor()
        let PulseView = MMPulseView()
        PulseView.frame = CGRectMake((pulsev.frame.size.width - 130)/2,(pulsev.frame.size.height - 130)/2,130,130);
        let annotationImage = UIView.init(frame: CGRectMake(((pulsev.frame.size.width) - 50)/2,((pulsev.frame.size.height) - 50)/2, 50, 50))
        annotationImage.backgroundColor = UIColor.init(patternImage: UIImage.init(named:"redpin.png")!)
        let imageView = UIImageView.init(frame: CGRectMake(13,8, 25, 25))
        imageView.layer.masksToBounds = true
        imageView.image = UIImage.init(named: PersonimageName as String)
        imageView.layer.cornerRadius = imageView.frame.size.height/2
        annotationImage.addSubview(imageView)
        pulsev.addSubview(PulseView)
        pulsev.addSubview(annotationImage)
        pinView?.addSubview(pulsev)
        PulseView.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        

        PulseView.colors = [(UIColor.redColor().CGColor as AnyObject), (UIColor.blackColor().CGColor as AnyObject), (UIColor.orangeColor().CGColor as AnyObject)]

        PulseView.locations = [(0.3), (0.5), (0.7)]

        PulseView.minRadius = 0
        PulseView.maxRadius = 80
        
        PulseView.duration = 5
        PulseView.count = 20
        PulseView.lineWidth = 1.0
        PulseView.startAnimation()
        return pinView!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func HandleTab(sender: UITapGestureRecognizer) {
        let location = sender.locationInView(self.view.superview!)
        print("\(location.x)")
        print("\(location.y)")
        self.actofGesture(self)
    }
    func move(sender: AnyObject) {
        self.view.bringSubviewToFront((sender as! UIPanGestureRecognizer).view!)
        var translatedPoint = (sender as! UIPanGestureRecognizer).translationInView(self.view)
        if (sender as! UIPanGestureRecognizer).state == .Began {
            firstX = sender.view.center.x
            firstY = sender.view.center.y
        }
        translatedPoint = CGPointMake(firstX, firstY + translatedPoint.y)
        sender.view.center = translatedPoint
        if (sender as! UIPanGestureRecognizer).state == .Ended {
            let velocityX: CGFloat = (0.2 * (sender as! UIPanGestureRecognizer).velocityInView(self.view).x)
            let finalX: CGFloat = firstX
            var finalY: CGFloat = translatedPoint.y + (0.35 * (sender as! UIPanGestureRecognizer).velocityInView(self.view).y)
            print("\(translatedPoint.y)")
            if translatedPoint.y < 888 {
                finalY = 504
                gestureIcon.image = UIImage.init(named: "down")
            }
            else if translatedPoint.y > 504 {
                finalY = 888;
                gestureIcon.image = UIImage.init(named: "up")
            }
            let animationDuration: CGFloat = (abs(velocityX) * 0.0002) + 0.2
            print("\(finalX) , \(finalY)")
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(NSTimeInterval(animationDuration))
            UIView.setAnimationCurve(.EaseOut)
            UIView.setAnimationDelegate(self)
//            UIView.setAnimationDidStopSelector(#selector(self.animationDidFinish))
            sender.view.center = CGPointMake(finalX, finalY)
            UIView.commitAnimations()
        }
    }
    
   

    @IBAction func actofGesture(sender: AnyObject)
    {
        var finalY: CGFloat
        let finalX: CGFloat = self.gestureview.center.x
        print("\(self.gestureview.center.y)")
        if self.gestureview
            .center.y >= 888 {
            finalY = 504
            gestureIcon.image = UIImage.init(named: "down.png")
        }
        else {
            finalY = 888
            gestureIcon.image = UIImage.init(named: "up.png")
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(NSTimeInterval( 0.4))
        UIView.setAnimationCurve(.EaseOut)
        UIView.setAnimationDelegate(self)
        //        UIView.setAnimationDidStopSelector( #selector(self.animationDidFinish))
        self.gestureview.center = CGPointMake(finalX, finalY)
        UIView.commitAnimations()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableArr.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DatingPersonCell") as! DatingPersonCell
        cell.Profileimage.setImageWithURL(NSURL(string:"")!, placeholderImage: UIImage(named:TableArr[indexPath.row].valueForKey("imagename")as! String))

        cell.name.text = TableArr[indexPath.row].valueForKey("name")as? String
        cell.distanceLbl.text = TableArr[indexPath.row].valueForKey("distance")as? String
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: TableArr[indexPath.row].valueForKey("lat")!.doubleValue, longitude: TableArr[indexPath.row].valueForKey("lon")!.doubleValue)
        let annotation = MKPointAnnotation()
        annotation.title = TableArr[indexPath.row].valueForKey("name") as? String
        annotation.subtitle = TableArr[indexPath.row].valueForKey("distance") as? String
        annotation.coordinate = coordinate
        self.mapview.addAnnotation(annotation)
        PersonimageName = TableArr[indexPath.row].valueForKey("imagename") as! String
        self.actofGesture(self)
    }
    
  
}
