using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemySpeed : MonoBehaviour
{
    private void OnTriggerEnter(Collider collision)
    {
        collision.gameObject.GetComponent<CharaMove>().kahen();
    }

}
