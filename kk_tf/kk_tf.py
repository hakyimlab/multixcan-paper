#!/usr/bin/env python
__author__ = "alvaro barbeira"

import numpy
import pandas
import tensorflow as tf
from tensorflow import keras
from sklearn.model_selection import train_test_split

def _n(x):
    return (x - numpy.mean(x))/numpy.std(x)

d = pandas.read_table("../results/smultixcan_wrong.txt")
d_ = d.loc[d.n>1]
d_ = d_.assign(pvalue = numpy.maximum(d_.pvalue, 1e-30), p_i_best=numpy.maximum(d_.p_i_best, 1e-30))
d_ = d_.assign(i = range(0, d_.shape[0]), s_best = -numpy.log10(d_.p_i_best), n_prop = d_.n_indep/d_.n, s=-numpy.log10(d_.pvalue))
d_ = d_.assign(s = _n(d_.s), s_best=_n(d_.s_best), n_prop = _n(d_.n_prop), eigen_max = _n(d_.eigen_max), eigen_min =_n(d_.eigen_min))

right = numpy.array([1 if x else 0 for x in d_.right.values])
data = numpy.matrix([d_.s.values, d_.s_best.values, d_.z_sd.values, d_.n_prop.values, d_.eigen_max.values, d_.eigen_min.values]).T

X_train, X_test, y_train, y_test = train_test_split(data, right, test_size=0.2, random_state=1)

from IPython import embed; embed(); exit()

x_placeholder = tf.placeholder(X_train.dtype, X_train.shape)
y_placeholder = tf.placeholder(y_train.dtype, y_train.shape)

# model = keras.Sequential([
#     keras.layers.Dense(32, activation=tf.nn.relu, input_shape=(X_train.shape[1],)),
#     keras.layers.Dense(2, activation=tf.nn.softmax)

#
# ])

# model.compile(optimizer=tf.train.AdamOptimizer(),
#               loss='sparse_categorical_crossentropy',
#               metrics=['accuracy'])

model = keras.Sequential([
    keras.layers.Dense(64, activation=tf.nn.relu,
                       input_shape=(X_train.shape[1],)),
    keras.layers.Dense(64, activation=tf.nn.relu),
    keras.layers.Dense(1)
  ])

optimizer = tf.train.RMSPropOptimizer(0.001)

model.compile(loss='mse',
        optimizer=optimizer,
        metrics=['mae'])



#model.fit(x_placeholder, y_placeholder, epochs=5)
history = model.fit(X_train, y_train, epochs=5)

p = model.predict(X_test)
#p_ = numpy.array([x[1] for x in p])
#numpy.sum((y_test-p_)**2)/p_.shape