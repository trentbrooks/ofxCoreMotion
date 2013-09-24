
#include "ofxCoreMotion.h"


ofxCoreMotion::ofxCoreMotion() {
    
    motionManager = [[CMMotionManager alloc] init];
    referenceAttitude = nil;
    updateFrequency = 1.0f/ofGetFrameRate();
    roll = pitch = yaw = 0;
    enableAttitude = false;
    enableGyro = false;
    enableAccelerometer = false;
    enableMagnetometer = false;
}


ofxCoreMotion::~ofxCoreMotion() {
    
    [referenceAttitude release];
    referenceAttitude = nil;
    [motionManager stopAccelerometerUpdates];
    [motionManager stopGyroUpdates];
    [motionManager stopMagnetometerUpdates];
    [motionManager stopDeviceMotionUpdates];
    [motionManager release];
    motionManager = nil;
}

void ofxCoreMotion::setup(bool enableAttitude, bool enableAccelerometer, bool enableGyro, bool enableMagnetometer) {
    
    if(enableAttitude) setupAttitude();
    if(enableAccelerometer) setupAccelerometer();
    if(enableGyro) setupGyroscope();
    if(enableMagnetometer) setupMagnetometer();
}

void ofxCoreMotion::resetAttitude() {
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
	CMAttitude *attitude = deviceMotion.attitude;
    referenceAttitude = [attitude retain];
}

void ofxCoreMotion::setupAttitude() {
    
    enableAttitude = true;
    
    // by default let's not use a reference frame so orients to default
    /*CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
	CMAttitude *attitude = deviceMotion.attitude;
    referenceAttitude = [attitude retain];*/
    
    [motionManager setDeviceMotionUpdateInterval: updateFrequency];
    [motionManager startDeviceMotionUpdates];
    //[motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];

}

void ofxCoreMotion::setupAccelerometer() {
    
    enableAccelerometer = true;
    [motionManager setAccelerometerUpdateInterval:updateFrequency];
    [motionManager startAccelerometerUpdates];
}

void ofxCoreMotion::setupGyroscope() {
    
    enableGyro = true;
    [motionManager setGyroUpdateInterval:updateFrequency];
    [motionManager startGyroUpdates];
}


void ofxCoreMotion::setupMagnetometer() {
    
    enableMagnetometer = true;
    [motionManager setMagnetometerUpdateInterval:updateFrequency];
    [motionManager startMagnetometerUpdates];
}

void ofxCoreMotion::setUpdateFrequency(float updateFrequency) {
    
    // default = 1.0f/ofGetFrameRate();
    this->updateFrequency = updateFrequency;
    if(enableAttitude) [motionManager setDeviceMotionUpdateInterval: updateFrequency];
    if(enableAccelerometer) [motionManager setAccelerometerUpdateInterval:updateFrequency];
    if(enableGyro) [motionManager setGyroUpdateInterval:updateFrequency];
    if(enableMagnetometer) [motionManager setMagnetometerUpdateInterval:updateFrequency];
}


// convenience method to update all objc properties to OF friendly at once
void ofxCoreMotion::update() {
    
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    
    if(enableAttitude) {
              
        CMAttitude *attitude = deviceMotion.attitude;
        if (referenceAttitude != nil ) {
            [attitude multiplyByInverseOfAttitude:referenceAttitude];
        }
        
        // attitude euler angles
        roll = attitude.roll;
        pitch = attitude.pitch;
        yaw	= attitude.yaw;
        
        // attitude quaternion
        CMQuaternion quat = attitude.quaternion;
        attitudeQuat.set(quat.x, quat.y, quat.z, quat.w);

        // attitude rotation matrix
        CMRotationMatrix rot = attitude.rotationMatrix;
        rotMatrix.set(rot.m11, rot.m21, rot.m31, 0,
                      rot.m12, rot.m22, rot.m32, 0,
                      rot.m13, rot.m23, rot.m33, 0,
                      0, 0, 0, 1);
        /*rotMatrix[0] = rot.m11; rotMatrix[1] = rot.m21; rotMatrix[2] = rot.m31;  rotMatrix[3] = 0;
        rotMatrix[4] = rot.m12; rotMatrix[5] = rot.m22; rotMatrix[6] = rot.m32;  rotMatrix[7] = 0;
        rotMatrix[8] = rot.m13; rotMatrix[9] = rot.m23; rotMatrix[10] = rot.m33; rotMatrix[11] = 0;
        rotMatrix[12] = 0;      rotMatrix[13] = 0;      rotMatrix[14] = 0;       rotMatrix[15] = 1;*/
    }
    
    if(enableAccelerometer) {
        CMAccelerometerData* acc = motionManager.accelerometerData;        
        accelerometerData.x = acc.acceleration.x;
        accelerometerData.y = acc.acceleration.y;
        accelerometerData.z = acc.acceleration.z;
    }
    
    if(enableGyro) {
        CMGyroData* gyro = motionManager.gyroData;
        gyroscopeData.x = gyro.rotationRate.x;
        gyroscopeData.y = gyro.rotationRate.y;
        gyroscopeData.z = gyro.rotationRate.z;
    }
    
    if(enableMagnetometer) {
        CMMagnetometerData *mag = motionManager.magnetometerData;
        magnetometerData.x = mag.magneticField.x;
        magnetometerData.y = mag.magneticField.y;
        magnetometerData.z = mag.magneticField.z;
    }
}

ofVec3f ofxCoreMotion::getAccelerometerData() {
    return accelerometerData;
}

ofVec3f ofxCoreMotion::getGyroscopeData() {
    return gyroscopeData;
}

ofVec3f ofxCoreMotion::getMagnetometerData() {
    return magnetometerData;
}

float ofxCoreMotion::getRoll() {
    return roll;
}

float ofxCoreMotion::getPitch() {
    return pitch;
}

float ofxCoreMotion::getYaw() {
    return yaw;
}

ofQuaternion ofxCoreMotion::getQuaternion() {
    return attitudeQuat;
}

ofMatrix4x4 ofxCoreMotion::getRotationMatrix() {
    return rotMatrix;
}

