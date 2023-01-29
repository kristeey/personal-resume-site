import React from 'react';
import { View, StyleSheet } from '@react-pdf/renderer';
import PropTypes from 'prop-types';

const styles = StyleSheet.create({
  paddingBlock: {
    width: '100%',
    position: 'absolute',
    right: 0,

  }
});

const validPlacements = ['top', 'bottom'];

function checkValidProp(arr, prop) {
  if (!arr.includes(prop)) {
    return false;
  }
  return true;
}

const Padding= ({color, placement, height, widthFromRight}) => {
  var p_temp = placement;
  if (!checkValidProp(validPlacements, placement)){
    console.error(`${placement} is not a valid property. Uses default placement 'top'.`);
    p_temp ='top';
  }
  if (p_temp == 'bottom') {
    return (
      <View 
        style={[
          styles.paddingBlock, 
          {
            backgroundColor: color, 
            bottom: 0,
            height: height,
            width: widthFromRight,
          }
        ]}
        fixed
      />
    )
  } else {
    return (
      <View 
        style={[
          styles.paddingBlock, 
          {
            backgroundColor: color, 
            top: 0,
            height: height,
            width: widthFromRight,
          }
        ]}
        fixed
      />
    )
  }
};

Padding.propTypes = {
  color: PropTypes.string,
  placement: PropTypes.string,
  height: PropTypes.number,
  widthFromRight: PropTypes.number,
};

Padding.defaultProps = {
  color: 'white',
  placement: 'top',
  height: 30,
  widthFromRight: 420.53
};

export default Padding;
