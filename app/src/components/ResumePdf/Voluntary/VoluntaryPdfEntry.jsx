import React from 'react';
import PropTypes from 'prop-types';
import { View, Text, StyleSheet } from '@react-pdf/renderer';
import List, {Item} from '../Setup/List'

const styles = StyleSheet.create({
  entryContainer: {
    marginBottom: 10,
  },
  date: {
    fontSize: 11,
    fontFamily: 'Raleway',
    fontWeight: 200,
  },
  title: {
    fontSize: 11,
    color: 'black',
    textDecoration: 'none',
    fontFamily: 'Raleway',
    fontWeight: 800,
  },
  detailContainer: {
    fontSize: 11,
    fontFamily: 'Raleway',
    fontWeight: 400,
  },
});

const VoluntaryPdfEntry = ({ data }) => {
  return (
    <View wrap={false} style={styles.entryContainer}>
      <View>
        <Text style={styles.title}>{data.title}</Text>
        <Text style={styles.date}>{data.daterange}</Text>
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

VoluntaryPdfEntry.propTypes = {
  data: PropTypes.shape({
    title: PropTypes.string.isRequired,
    daterange: PropTypes.string.isRequired,
    points: PropTypes.arrayOf(PropTypes.string).isRequired,
  }).isRequired,
};

export default VoluntaryPdfEntry;
