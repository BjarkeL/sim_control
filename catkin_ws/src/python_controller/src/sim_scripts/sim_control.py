import rospy
from std_msgs.msg import Bool, Float32, Int32, Float32MultiArray
import numpy as np
from cpp_functions import functions
 
class SimControl(object):

    def __init__(self):
        self.start_sim = rospy.Publisher('startSimulation', Bool, latch=True, queue_size=1)
        self.stop_sim = rospy.Publisher('stopSimulation', Bool, latch=True, queue_size=1)
        # Publisher for enabling sync mode:
        self.en_sync = rospy.Publisher('enableSyncMode', Bool, latch=True, queue_size=1)
        # Publisher for stepping the simulator:
        self.step_sim = rospy.Publisher('triggerNextStep', Bool, latch=True, queue_size=1)
        # Subscriber for the state of the simulator:
        self.sim_state = rospy.Subscriber('simulationState', Int32, self.state_callback)

        # Robot publishers
        self.motor_pub = rospy.Publisher('motor_command', Float32MultiArray, queue_size=1)
        
        # Variables
        self.inc = 0.01
        self.vel = [-2,-1]

        # Init the ROS node
        rospy.init_node('sim_controller', anonymous=True)
        self.state = None

    def state_callback(self, msg):
        data = msg.data
        self.state = data

    def start_sequence(self):
        self.start_sim.publish(Bool(data=True))
        self.en_sync.publish(Bool(data=True))
        while self.state != 1:
            rospy.sleep(1) # Arbitrary delay to only step a few times before the simulator starts.
            self.step_sim.publish(Bool(data=True))

    def perform_action(self):
        self.vel[0] += self.inc
        self.vel[1] += self.inc
        if self.vel[0] > 2 or self.vel[0] < -2:
            self.inc = -self.inc
        self.motor_pub.publish(Float32MultiArray(data=self.vel))
    
    def main_control(self):
        self.start_sequence()

        print(functions.add(2,3)) # Just a test to demonstrate including c++ functions.

        while not rospy.is_shutdown():
            self.perform_action() # Communicate with the simulator and perform calculations.
            self.step_sim.publish(Bool(data=True)) # Steps the simulator.
            # Remember to latch the simulationStepDone if there is no callback.
            # If there is a callback on simulationStepDone then no latch.
            rospy.wait_for_message('simulationStepDone', Bool) # Ensures that it waits for the simulation to signal done.
            if self.state == 0: # Stops the script if the simulator is stopped.
                break # Seems to clean up the node properly when breaking instead of exit().


def run():
    run = SimControl()
    try:
        run.main_control()
    except rospy.ROSInterruptException:
        pass