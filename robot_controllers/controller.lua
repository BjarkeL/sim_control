
function motor_cb(msg)
    data=msg.data
    vLeft=data[1]
    vRight=data[2]
end

function sysCall_init()
    usensors={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1}
    for i=1,16,1 do
        usensors[i]=sim.getObjectHandle("Pioneer_p3dx_ultrasonicSensor"..i)
    end
    motorLeft=sim.getObjectHandle("Pioneer_p3dx_leftMotor")
    motorRight=sim.getObjectHandle("Pioneer_p3dx_rightMotor")

    -- The child script initialization
    objectHandle=sim.getObjectAssociatedWithScript(sim.handle_self)
    objectName=sim.getObjectName(objectHandle)
    rosInterfacePresent=simROS

    if rosInterfacePresent then
        motor_subscriber=simROS.subscribe('/motor_command','std_msgs/Float32MultiArray','motor_cb')
        test_publisher=simROS.advertise('/test','std_msgs/Float32')
    end
end

function sysCall_actuation()
    -- This could also be performed in the callback instead
    -- since the callback only runs once every cycle anyways.
    if vLeft ~= nil then
        sim.setJointTargetVelocity(motorLeft,vLeft)
        sim.setJointTargetVelocity(motorRight,vRight)
    end
end

function sysCall_sensing()
    -- Handle sensors
    simROS.publish(test_publisher,{data=1})
end

function sysCall_cleanup()
    simROS.shutdownSubscriber(motor_subscriber)
    simROS.shutdownPublisher(test_publisher)
end