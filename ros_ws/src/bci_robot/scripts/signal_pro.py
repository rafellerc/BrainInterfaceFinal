#!/usr/bin/env python
import rospy
from std_msgs.msg import Float64
from geometry_msgs.msg import Twist
import numpy as np
import sys

class Signal_processer(object):

    def __init__(self, G=0.56, delta_f=0.46, alpha=0.96, bufferSize=32, fe = 256,
                speed = 0.1, aspeed = 0.5, thold = [2.9e-06, 1.7e-06, 1.4e-06],mode='turtle'):
        '''Initializes the signal processor with the optimal and default parameters.
        The speed parameters were chosen as to run it safely in a small room.
        '''
        self.fe = fe
        self.fcent = [7.5, 11, 13.5]  #The central frequencies of the flashing lights
        self.a1 = [-2 * np.sqrt(1 - (2 * np.pi * G * delta_f) / fe) * np.cos(2 * np.pi * fc / fe) for fc in self.fcent]
        self.a2 = 1 - (2 * np.pi * G * delta_f) / fe  #Equal for the 3 frequencies
        self.b0 = [(2 * np.pi * G * delta_f / fe) * np.sin(2 * np.pi * fc / fe) for fc in self.fcent]

        self.alpha = alpha
        self.N = bufferSize #Stores the bufferSize in a variable N

        #Variable that stores the current output of the pass-band filters in position 0
        #and two of its previous values, each column represents a slice of time and each
        #line represents the signal filtered in one of the given frequencies
        self.y = np.zeros([3,3])
        #Buffer that stores all the 3 filtered and smoothed signals
        self.buffer_z = np.zeros([3,bufferSize])
        #Counter that keeps track of the current write position on the buffers
        self.i = 0;
        #Definition of the forward speed everytime there is a forward command
        self.speed = speed
        #Definition of the angular speed everytime there is a right or left command
        self.aspeed = aspeed
        #A Twist message. It is going to be stored as a member of the class to avoid
        #creating the message multiple times
        self.msg = Twist()
        self.msg.linear.x = 0
        self.msg.linear.y = 0
        self.msg.linear.z = 0
        self.msg.angular.x = 0
        self.msg.angular.y = 0
        self.msg.angular.z = 0
        #Stores the current command, between ['Stop','Forward','Left','Right']
        self.curcom = 'Stop'
        #Definition of the 3 Thresholds that will be used to extract the commands
        self.thold = thold

        #---ROS members---
        rospy.init_node('signal_processing', anonymous=True)
        self.sub = rospy.Subscriber("dataBCI", Float64, self.callback_data_listen)

        #Select the appropriate Topic. The first one corresponds to the turtlesim
        #node available in the standard ROS package. The second is the Khepera bot
        if mode == 'turtle':
            self.pub = rospy.Publisher("/turtle1/cmd_vel",Twist, queue_size=10)
        elif mode == 'khepera':
            self.pub = rospy.Publisher("/cmd_vel",Twist, queue_size=10)
        else:
            print("Incorrect Input: The normal usage of the node is")
            print("---For testing locally in a turtlesim node---")
            print("rosrun bci_robot signal_pro.py turtle")
            print("---For running while connected to a kephera robot---")
            print("rosrun bci_robot signal_pro.py kephera")
            raise ValueError("Incorrect call to ROS node")


        #The adress of the robot is khepera2.smart.metz.supelec.fr or khepera1...
        #Do a ping on it to get the IP address and then to launch the node
        #roslaunch kteams_node khepera_bringup.launch khepera_dns:=THE_IP_OF_THE_ROBOT

    def callback_data_listen(self,sample):
        """This callback corresponds to all the processing that happens once the node
        receives a message from the BCI source. It treats the samples one by one
        at the sampling frequency (256 Hz for the stored files) and stores them in
        a buffer of size defined in the class initialization.
        """
        #Starts by shifting the columns of y by one position to the right
        self.increment_y()
        #Then apllies the 3 filters to the current sample
        self.apply_filter(sample.data)
        #Finally
        self.apply_p_estimation()

        #Checks if the buffer is full, if it's the case, it resets the counter and
        #calls a publishing callback that will finish the signal processing and
        #then publish the appropriate message.
        if self.i == self.N-1:
            self.i = 0
            self.callback_pub()
        else:
            self.i+=1

    def exec_(self):
        """Executes the nodes
        """
        rospy.spin()

    def callback_pub(self):
        """This method corresponds to the publishing callback, called each time
        the signal buffer is full. Its publishing frequency depends on the frequency (fs)
        of the source and the size of the buffer (N) and it is about fs/N.
        """
        #Gets the current command
        self.get_command()
        #Publishes the current command in the appropriate topic
        self.pub.publish(self.msg)
        #Displays the current command
        print(self.curcom)

    def increment_y(self):
        """This function increments y by one interval by shifting its elements one
        position to the right.
        """
        self.y[:,1:3] = self.y[:,0:2]

    def apply_filter(self, x):
        """This method applies the 3 second order FIR filters defined by the 'a'
        and 'b' parameters.
        """
        self.y[:,0] = [self.b0[i]*x - self.a1[i]*self.y[i,1] - self.a2*self.y[i,2] for i in [0,1,2]]

    def apply_p_estimation(self):
        """Applies a smoothing power estimation for each of the 3 filtered signals
        to get the power content in each frequency.
        """
        for j in [0,1,2]:
            self.buffer_z[j,self.i] = (1-self.alpha)*(self.y[j,0])**2 + self.alpha*(self.buffer_z[j,(self.i-1)%self.N])

    def get_command(self):
        """This method decides from the full z_buffer what the corresponding command
        should be (stop, right, left, or forward). It uses all the initialization definitions
        of the amounts that each command represent in terms of actual speeds. It returns
        a Twist message.
        """
        #TODO do the processing
        mean = self.buffer_z.mean(axis=1)
        #Divides by each threshold, so each signal can be compared to 1 instead of
        #the threshold, and then if there is at least one signal bigger than the
        #threshold it suffices to choose the biggest between the 3
        for i in [0,1,2]:
            mean[i]=mean[i]/self.thold[i]

        if mean[0] <= 1 and mean[1] <= 1 and mean[2] <= 1:
            #Do nothing
            self.msg.linear.x = 0
            self.msg.angular.z = 0
            self.curcom = 'Stop'
        elif mean[0] >= mean[1] and mean[0] >= mean[2]:
            #Turn Left
            self.msg.linear.x = 0
            self.msg.angular.z = self.aspeed
            self.curcom = 'Left'
        elif mean[1] >= mean[0] and mean[1] >= mean[2]:
            #Move Forward
            self.msg.linear.x = self.speed
            self.msg.angular.z = 0
            self.curcom = 'Forward'
        elif mean[2] >= mean[0] and mean[2] >= mean[1]:
            #Turn Right
            self.msg.linear.x = 0
            self.msg.angular.z = -self.aspeed
            self.curcom = 'Right'
        else:
            print("Error in get_command, your code sucks")



if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Incorrect Input: The normal usage of the node is")
        print("---For testing locally in a turtlesim node---")
        print("rosrun bci_robot signal_pro.py turtle")
        print("---For running while connected to a kephera robot---")
        print("rosrun bci_robot signal_pro.py kephera")
        raise ValueError("Incorrect call to ROS node")
    try:
        print("Initializing the signal_processing node in mode: {}".format(sys.argv[1]))
        sigpro = Signal_processer(mode=sys.argv[1])
        print('Node up and running')
        sigpro.exec_()
    except rospy.ROSInterruptException:
        pass
