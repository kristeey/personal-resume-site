import React from 'react';
import PropTypes from 'prop-types';

import { View, Text, StyleSheet } from '@react-pdf/renderer';
import List, {Item} from '../Setup/List'

const styles = StyleSheet.create({
  entryContainer: {
    marginBottom: 10,
  },
  date: {
    fontSize: 10,
    fontFamily: 'Raleway',
    fontWeight: 200,
  },
  title: {
    fontSize: 10,
    color: 'black',
    textDecoration: 'none',
    fontFamily: 'Raleway',
    fontWeight: 800,
  },
  detailContainer: {
    fontSize: 10,
    fontFamily: 'Raleway',
    fontWeight: 400,
  }
});

const ExperiencePdfEntry = ({ data }) => {
  return (
    <View wrap={false} style={styles.entryContainer}>
      <View>
        <Text style={styles.title}>{data.company} - {data.position}</Text>
        <Text style={styles.date}>{data.daterange} | {data.positionType}</Text>
      </View>
      <List>
        {data.points.map((point) => (
          <Item key={point} style={styles.detailContainer}>
            {point}
          </Item>
        ))}
      </List>
    </View>
  );
};

ExperiencePdfEntry.propTypes = {
  data: PropTypes.shape({
    company: PropTypes.string.isRequired,
    position: PropTypes.string.isRequired,
    positionType: PropTypes.string.isRequired,
    daterange: PropTypes.string.isRequired,
    points: PropTypes.arrayOf(PropTypes.string).isRequired,
  }).isRequired,
};

ExperiencePdfEntry.defaultProps = {
  data: [],
};

export default ExperiencePdfEntry;
