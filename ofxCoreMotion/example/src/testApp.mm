#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup(){	
	// initialize the accelerometer
	//ofxAccelerometer.setup();
	
	//If you want a landscape oreintation 
	//iPhoneSetOrientation(OFXIPHONE_ORIENTATION_LANDSCAPE_RIGHT);
	
	ofBackground(127,127,127);
    
    bool enableAttitude = true; // roll,pitch,yaw
    bool enableAccelerometer = true;
    bool enableGyro = true;
    bool enableMagnetometer = true ;
    coreMotion.setup(enableAttitude,enableAccelerometer,enableGyro,enableMagnetometer);
}

//--------------------------------------------------------------
void testApp::update(){

    coreMotion.update();
}

//--------------------------------------------------------------
void testApp::draw(){
	
    ofBackground(255, 255, 0);
    
    // attitude- quaternion
    ofDrawBitmapStringHighlight("Attitude: (quaternion x,y,z,w)", 20, 25);
    ofSetColor(0);
    ofQuaternion quat = coreMotion.getQuaternion();
    ofDrawBitmapString(ofToString(quat.x(),3), 20, 50);
    ofDrawBitmapString(ofToString(quat.y(),3), 90, 50);
    ofDrawBitmapString(ofToString(quat.z(),3), 160, 50);
    ofDrawBitmapString(ofToString(quat.w(),3), 230, 50);
    
    // attitude- roll,pitch,yaw
    ofDrawBitmapStringHighlight("Attitude: (roll,pitch,yaw)", 20, 75);
    ofSetColor(0);
    ofDrawBitmapString(ofToString(coreMotion.getRoll(),3), 20, 100);
    ofDrawBitmapString(ofToString(coreMotion.getPitch(),3), 120, 100);
    ofDrawBitmapString(ofToString(coreMotion.getYaw(),3), 220, 100);
    
    // accelerometer
    ofVec3f a = coreMotion.getAccelerometerData();
    ofDrawBitmapStringHighlight("Accelerometer: (x,y,z)", 20, 125);
    ofSetColor(0);
    ofDrawBitmapString(ofToString(a.x,3), 20, 150);
    ofDrawBitmapString(ofToString(a.y,3), 120, 150);
    ofDrawBitmapString(ofToString(a.z,3), 220, 150);
    
    // gyroscope
    ofVec3f g = coreMotion.getGyroscopeData();
    ofDrawBitmapStringHighlight("Gyroscope: (x,y,z)", 20, 175);
    ofSetColor(0);
    ofDrawBitmapString(ofToString(g.x,3), 20, 200 );
    ofDrawBitmapString(ofToString(g.y,3), 120, 200 );
    ofDrawBitmapString(ofToString(g.z,3), 220, 200 );

    // magnetometer
    ofVec3f m = coreMotion.getMagnetometerData();
    ofDrawBitmapStringHighlight("Magnetometer: (x,y,z)", 20, 225);
    ofSetColor(0);
    ofDrawBitmapString(ofToString(m.x,3), 20, 250);
    ofDrawBitmapString(ofToString(m.y,3), 120, 250);
    ofDrawBitmapString(ofToString(m.z,3), 220, 250);
    
    // draw a cube and rotate with quaternion
    ofVec3f axis;  
    float angle;  
    quat.getRotate(angle, axis);  
    
    ofNoFill();
    ofPushMatrix();  
    ofTranslate(ofGetWidth()/2, ofGetHeight()/2);  
    ofRotate(angle, axis.x, axis.y, axis.z);  
	ofBox(0, 0, 220);
    ofDrawAxis(100);
    ofPopMatrix();
    ofFill();
}

//--------------------------------------------------------------
void testApp::exit(){

}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

    coreMotion.resetAttitude();
}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void testApp::lostFocus(){

}

//--------------------------------------------------------------
void testApp::gotFocus(){

}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){

}

