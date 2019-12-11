Explain why we put each consecutive call inside the onSuccess callback of the previous database call, instead of just placing them next to each other.
If we were to put them side by side a later function might finish running before an earlier function. 
I.e. the 2nd function might finnish before the 1st function. Under some circumstances this might not be a porblem, but if the program demands that the 1st function finish before the 2nd starts then this is a problem.
Nesting the callbacks will ensure that the functions will finnish their run in a certain pre-defined order.