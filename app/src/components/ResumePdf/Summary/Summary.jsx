import { View, Text, StyleSheet, Font } from '@react-pdf/renderer';
import Title from '../Setup/Title';
import React from 'react';
import PropTypes from 'prop-types';

const styles = StyleSheet.create({
  container: {
    padding: 10,
  },
  summaryText: {
    fontSize: 14,
    fontFamily: 'Raleway',
    fontWeight: 400,
  }
});

Font.registerHyphenationCallback(create => [create]);

const Summary = ({ summary }) => (
  <View style={styles.container}>
    <Title>Summary</Title>
    <View>
      <Text style={styles.summaryText}>{summary}</Text>
    </View>
  </View>
);

Summary.propTypes = {
  summary: PropTypes.string.isRequired,
};

export default Summary;