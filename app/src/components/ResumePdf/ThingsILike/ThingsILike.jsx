import React from 'react';

import { View, Text, StyleSheet } from '@react-pdf/renderer';
import Title from '../Setup/Title';

const styles = StyleSheet.create({
  thingsILikeHeader: {
    fontFamily: 'Raleway',
    fontWeight: 800,
    fontSize: 11,
  },
  ThingsILikeSection: {
    display: 'flex',
    flexDirection: 'column',
  },
  ThingsILikeRow: {
    display: 'flex',
    flexDirection: 'row',
    marginRight: 100,
    justifyContent: 'space-between',
  },
  ThingsILikeText: {
    fontFamily: 'Raleway',
    fontWeight: 400,
    fontSize: 11,
  }
});

const ThingsILike = () => {
  return (
    <View>
      <Title>Things I Like</Title>
      <View style={styles.ThingsILikeSection}>
        <View style={styles.ThingsILikeRow}>
          <Text style={styles.ThingsILikeText}>Skiing</Text>
          <Text style={styles.ThingsILikeText}>Programming</Text>
        </View>
        <View style={styles.ThingsILikeRow}>
          <Text style={styles.ThingsILikeText}>Climbing</Text>
          <Text style={styles.ThingsILikeText}>Woodworking</Text>
        </View> 
        <View style={styles.ThingsILikeRow}>
          <Text style={styles.ThingsILikeText}>The ocean</Text>
          <Text style={styles.ThingsILikeText}>Solving problems</Text>
        </View> 
      </View>
    </View>
  );
};

export default ThingsILike;
