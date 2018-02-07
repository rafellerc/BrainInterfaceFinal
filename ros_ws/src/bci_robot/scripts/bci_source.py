#!/usr/bin/env python
import rospy
from std_msgs.msg import Float64
import numpy as np
import sys
from os import path


def bci_source(file_path):
    print("Initializing /bci_source")
    print("This node feeds a 256 Hz stream of samples from the BCI measurements,\
to a topic called dataBCI. The current version simulates the real-time acquisition\
of the signal by reading a text file containing real measurements.")

    #Reads all the information from the file
    X = np.loadtxt(file_path)
    #Separates the labels from the signal
    lab = X[:,1]
    X = X[:,0]

    pub = rospy.Publisher('dataBCI', Float64, queue_size=10) #Try other queue_sizes
    rospy.init_node('bci_source', anonymous=True)
    rate = rospy.Rate(256)
    sample = Float64()
    index = 0;
    Xmax = X.shape[0]

    #Variable that indicates that the program is starting (We thought about doing a countdown
    #or trying to do a handshake with the listener node, to guarantee they are synchronized)
    begin = True

    while not rospy.is_shutdown() and index != Xmax-1:
        #reads and publishes sample for sample at 256 Hz
        sample.data = X[index]
        index+=1
        print(get_command(lab[index]))
        # print(sample)
        pub.publish(sample)
        rate.sleep()

    print("Finished publishing the data from file")

def get_command(num):
    """This function translates the label used to annotate the signals to the corresponding commands
    """
    if num == 0:
        return 'Stop'
    elif num == 1:
        return 'Forward'
    elif num == 2:
        return 'Right'
    elif num == 3:
        return 'Left'

if __name__ == '__main__':
    if len(sys.argv) == 1:
        #----------ATTENTION-----------------------
        #This is a hard-coded section, you're NOT required to use it. It exists to make it
        #easier and faster to call the node, as it does not require to inform the full path of
        #the file as argument in the console.

        #TO USE IT substitute the path for the appropriate one in your system.
        file_path = '/home/rafael/dev/sir/TL-Approf.-BCI/obj/herve002_labeled.txt'

        if path.isfile(file_path):
            print("Opening file in {}".format(file_path))
        else:
            print("Wrong usage: Try informing in the console the full path to the signal file, for example:")
            print("rosrun bci_robot bci_source.py /home/user/project/obj/herve002_labeled.txt")
            raise ValueError("{} is not a valid path".format(file_path))

    elif len(sys.argv) == 2:
        #This is the normal usage of this program, you should inform the full path of the
        #file containing the signal to be published by this node. The labeled files are
        #normally in the /obj/ folder of the project.
        file_path = sys.argv[1]

    try:
        bci_source(file_path)
    except rospy.ROSInterruptException:
        pass
