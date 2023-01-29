import React from 'react';
import PropTypes from 'prop-types';

import { View, Text, StyleSheet } from '@react-pdf/renderer';
import List, {Item} from './List';

const styles = StyleSheet.create({
  sidebarListHeader: {
    fontFamily: 'Raleway',
    fontWeight: 800,
    fontSize: 11,
  },
  sidebarListSection: {
    display: 'flex',
    flexDirection: 'column',
  },
  sidebarListText: {
    fontFamily: 'Raleway',
    fontWeight: 400,
    fontSize: 11,
  }
});

const SidebarList = ({header, points}) => (
  <View style={styles.sidebarListSection}>
    <Text style={styles.sidebarListHeader}>
      {header}
    </Text>
    <List>
      {points.map((point) => (
        <Item key={point}>
          {point}
        </Item>
      ))}
    </List>
  </View>
);

SidebarList.propTypes = {
  header: PropTypes.string.isRequired,
  points: PropTypes.arrayOf(PropTypes.string).isRequired,
};

export default SidebarList;