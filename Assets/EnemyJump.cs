using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyJump : MonoBehaviour
{
    private void OnCollisionEnter(Collision collision)
    {
        collision.gameObject.GetComponent<CharaMove>().JumpA();
        collision.gameObject.GetComponent<Rigidbody>().AddForce(Vector3.up * 10,ForceMode.Impulse);
    }
}
